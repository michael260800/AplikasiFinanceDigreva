# DIGREVA Finance

Starter aplikasi manajemen keuangan untuk usaha jasa digital kreatif DIGREVA. Stack: Next.js 14, TypeScript, Tailwind CSS, Recharts, Supabase Auth, dan PostgreSQL.

## Fitur yang sudah tersedia

- Dashboard pemasukan, pengeluaran, saldo pencatatan, piutang proyek, dan nilai proyek berjalan.
- Grafik arus kas enam bulan dan komposisi biaya per kategori.
- CRUD transaksi (tambah, edit, hapus), pencarian, filter, dan ekspor CSV.
- Daftar proyek klien, status, nilai kontrak, pembayaran tercatat, biaya, dan estimasi laba.
- Ringkasan invoice/piutang.
- Pengelolaan akun kas/rekening dan saldo awal.
- Laporan ringkas periode terpilih.
- Mode demo lokal agar tampilan dapat dicoba tanpa Supabase.
- Supabase Auth dan RLS ketika Supabase dikonfigurasi.

## Prasyarat

1. Node.js 20 LTS atau versi LTS yang kompatibel.
2. npm.
3. VS Code.
4. (Opsional untuk penyimpanan cloud) akun dan proyek Supabase.

## Menjalankan di VS Code

1. Ekstrak ZIP, lalu buka folder `digreva-finance` di VS Code.
2. Buka menu **Terminal > New Terminal**.
3. Jalankan:

```bash
npm install
npm run dev
```

4. Buka `http://localhost:3000` di browser.

Tanpa konfigurasi Supabase, aplikasi masuk ke **mode lokal**. Transaksi dan proyek disimpan di `localStorage` browser. Data ini tidak tersinkron antarperangkat dan bukan penyimpanan produksi.

## Menghubungkan Supabase

1. Buat proyek baru di https://supabase.com.
2. Buka **SQL Editor** di dashboard Supabase.
3. Jalankan seluruh isi file `supabase/migration.sql`.
4. Buka **Project Settings > API** (atau bagian API Keys pada tampilan dashboard baru) dan salin Project URL serta publishable/anon key.
5. Salin `.env.example` menjadi `.env.local`.
6. Isi variabelnya:

```env
NEXT_PUBLIC_SUPABASE_URL=https://PROJECT_ID.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_OR_ANON_KEY
```

7. Simpan, hentikan server (`Ctrl+C`), lalu jalankan kembali `npm run dev`.
8. Buat akun melalui form pendaftaran. Jika verifikasi email aktif, verifikasi email sebelum login.

Jangan pernah menggunakan `service_role` key di frontend atau mengunggah `.env.local` ke GitHub.

## Struktur folder

```text
digreva-finance/
├── app/
│   ├── globals.css       # Styling dan layout responsif
│   ├── layout.tsx        # Root layout dan metadata
│   └── page.tsx          # Dashboard dan modul interaktif
├── lib/
│   └── supabase.ts       # Inisialisasi Supabase client
├── supabase/
│   └── migration.sql     # Tabel, constraint, indeks, dan RLS
├── .env.example
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```

## Deployment ke Vercel

1. Push project ke repository Git privat.
2. Import repository tersebut di https://vercel.com.
3. Tambahkan `NEXT_PUBLIC_SUPABASE_URL` dan `NEXT_PUBLIC_SUPABASE_ANON_KEY` pada Environment Variables Vercel.
4. Deploy. Pastikan URL situs ditambahkan ke pengaturan URL redirect/auth Supabase.

## Batasan starter yang perlu diketahui

Versi ini adalah fondasi MVP, bukan sistem akuntansi final. Sebelum dipakai sebagai sumber pembukuan resmi, perhatikan hal berikut:

- Modul proyek menyimpan angka `paid` secara terpisah. Pembayaran transaksi belum otomatis dialokasikan ke invoice/proyek; hindari memasukkan pembayaran yang sama ke dua perhitungan.
- Transfer internal antar rekening belum diimplementasikan.
- Invoice PDF, unggahan bukti, laporan Excel/PDF, audit log, backup otomatis, dan rekonsiliasi bank belum dibuat.
- Saldo awal akun harus mencerminkan saldo nyata pada tanggal mulai pencatatan. Data demo harus dihapus sebelum pencatatan aktual.
- RLS mengisolasi baris per pengguna. Ini belum merupakan model multi-anggota organisasi/role-based access.
- Mode lokal menggunakan `localStorage`; data dapat hilang jika browser storage dihapus.
- Laba proyek pada starter dihitung sebagai pembayaran yang dicatat (dibatasi harga kontrak) dikurangi estimasi biaya proyek, bukan laba rugi akuntansi berbasis pengakuan pendapatan.

## Pemeriksaan sebelum produksi

- Jalankan `npm run build`.
- Uji login/logout dan kebijakan RLS dengan dua akun berbeda.
- Uji input nominal, tanggal, kategori, dan saldo awal.
- Uji transaksi edit/hapus serta ekspor CSV.
- Tambahkan integrasi pembayaran-invoice dalam transaksi database atomik sebelum mengandalkan laporan piutang.
- Atur backup database dan prosedur pemulihan.
