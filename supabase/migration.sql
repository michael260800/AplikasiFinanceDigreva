-- DIGREVA Finance starter schema
-- Jalankan di Supabase Dashboard > SQL Editor.
-- Kebijakan RLS membatasi data setiap tabel kepada pengguna yang membuatnya.

create extension if not exists pgcrypto;

create table if not exists public.accounts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null check (length(trim(name)) > 0),
  kind text not null default 'Rekening bank',
  opening_balance numeric(18,2) not null default 0 check (opening_balance >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, name)
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null check (length(trim(name)) > 0),
  client_name text not null default '',
  service text not null default '',
  price numeric(18,2) not null default 0 check (price >= 0),
  paid numeric(18,2) not null default 0 check (paid >= 0),
  cost numeric(18,2) not null default 0 check (cost >= 0),
  start_date date,
  due_date date,
  status text not null default 'Prospek' check (status in ('Prospek','Menunggu DP','Dalam pengerjaan','Revisi','Selesai','Dibatalkan')),
  progress integer not null default 0 check (progress between 0 and 100),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  date date not null default current_date,
  type text not null check (type in ('income','expense')),
  category text not null default 'Lainnya',
  description text not null check (length(trim(description)) > 0),
  amount numeric(18,2) not null check (amount > 0),
  method text not null default 'Transfer bank',
  account_name text not null default '',
  client_name text not null default '',
  project_name text not null default '',
  reference text not null default '',
  notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists transactions_user_date_idx on public.transactions(user_id, date desc);
create index if not exists transactions_user_type_idx on public.transactions(user_id, type);
create index if not exists projects_user_status_idx on public.projects(user_id, status);
create index if not exists accounts_user_idx on public.accounts(user_id);

alter table public.accounts enable row level security;
alter table public.projects enable row level security;
alter table public.transactions enable row level security;

drop policy if exists "Users can manage their own accounts" on public.accounts;
create policy "Users can manage their own accounts" on public.accounts
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Users can manage their own projects" on public.projects;
create policy "Users can manage their own projects" on public.projects
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Users can manage their own transactions" on public.transactions;
create policy "Users can manage their own transactions" on public.transactions
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Optional updated_at trigger
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end;
$$;

drop trigger if exists accounts_set_updated_at on public.accounts;
create trigger accounts_set_updated_at before update on public.accounts for each row execute function public.set_updated_at();
drop trigger if exists projects_set_updated_at on public.projects;
create trigger projects_set_updated_at before update on public.projects for each row execute function public.set_updated_at();
drop trigger if exists transactions_set_updated_at on public.transactions;
create trigger transactions_set_updated_at before update on public.transactions for each row execute function public.set_updated_at();
