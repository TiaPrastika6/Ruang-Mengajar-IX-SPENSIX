# Panduan instalasi Ruang Mengajar IX

## 1. Buat database Supabase
1. Buat proyek baru di Supabase.
2. Buka **SQL Editor**.
3. Salin dan jalankan seluruh isi `schema.sql`.
4. Buka **Project Settings → API** dan salin Project URL serta publishable/anon key. Jangan pernah memakai `service_role` key di frontend.

## 2. Buat akun guru
1. Di Supabase, buka **Authentication → Users**.
2. Tambahkan akun untuk setiap guru yang diberi akses.
3. Setiap guru login memakai email dan password masing-masing. Jangan berbagi akun.
4. Untuk mengundang guru lain, pemilik proyek menambahkan akun lewat dashboard Supabase. Versi awal ini tidak menyediakan pendaftaran publik.

## 3. Jalankan web
Cara paling sederhana untuk uji coba: buka `index.html` melalui server lokal (misalnya VS Code Live Server) atau deploy ke GitHub Pages.
Saat halaman dibuka, masukkan Project URL dan publishable/anon key. Konfigurasi tersimpan di localStorage browser yang dipakai.

## 4. Format Excel
- File harus `.xlsx`.
- Setiap sheet mewakili satu kelas; nama sheet menjadi nama kelas persis.
- Setiap sheet memiliki header `Nama Siswa`; `NIS/NISN` boleh ada.
- Header yang dikenali: `Nama Siswa`, `Nama`, `Nama Lengkap`, `NIS`, `NISN`, `Nomor Induk`.
- Baris tanpa nama dilewati. Duplikat dalam sheet ditandai pada pratinjau.
- Unduh template dari halaman web lalu ganti nama sheet sesuai nama kelas sebenarnya.
- Pilih **Perbarui data** untuk operasi rutin. Mode sinkronisasi menonaktifkan siswa yang tidak ada di file untuk kelas yang termasuk dalam workbook, tetapi tidak menghapus riwayat.

## 5. Penting untuk keamanan
Kebijakan database di `schema.sql` memberi akses penuh kepada semua akun yang terautentikasi. Karena itu, hanya buat akun untuk guru tepercaya. Jangan aktifkan signup publik. Untuk produksi, pertimbangkan role admin/guru, audit log, backup berkala, dan kebijakan yang membatasi siapa yang boleh menghapus atau mengubah data.

## 6. Batasan versi awal
- Presensi menyimpan satu sesi per kelas per tanggal; jika kelas yang sama diajar lebih dari sekali sehari, skema perlu diperluas dengan nomor/sesi unik.
- Mode sinkronisasi menandai siswa yang hilang sebagai nonaktif, tidak menghapusnya.
- Rekap presensi menampilkan jumlah catatan per status dalam rentang tanggal, bukan persentase kehadiran per siswa.
- Ekspor Excel saat ini berisi sheet Presensi dan Nilai.
- Gunakan salinan file Excel terlebih dahulu untuk uji coba sebelum mengimpor data sekolah yang sebenarnya.
