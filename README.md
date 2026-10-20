# Ruang Mengajar IX
Web administrasi pembelajaran untuk 11 kelas IX: impor siswa dari Excel multi-sheet, presensi manual, jurnal materi, penilaian, rekap dan ekspor.

## File
- `index.html` — frontend web.
- `schema.sql` — tabel database dan kebijakan keamanan Supabase.
- `PANDUAN.md` — panduan pemasangan.

## Fitur implementasi awal
- Login guru melalui Supabase Auth.
- Impor `.xlsx` dengan satu sheet per kelas; nama sheet dipakai sebagai nama kelas.
- Validasi header nama siswa dan duplikat dalam sheet.
- Mode update dan sinkronisasi daftar siswa tanpa menghapus riwayat presensi/nilai.
- CRUD dasar siswa, presensi manual, jurnal materi, penilaian, rekap dan ekspor Excel.

## Catatan
Ini starter MVP yang perlu diuji dengan salinan data terlebih dahulu. Sebelum penggunaan resmi, uji impor, kebijakan akun guru, backup, serta skenario koreksi data. Jangan masukkan data siswa nyata ke demo publik.
