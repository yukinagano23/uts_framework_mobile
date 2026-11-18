# Catatan Tugas

Aplikasi sederhana untuk mencatat, memantau, dan menyelesaikan tugas harian. Dibuat dengan **Flutter** (bahasa Dart) sebagai latihan pengembangan aplikasi mobile.

## Fitur

- **Halaman penyambutan** berisi logo, nama aplikasi, dan tombol **Mulai**.
- **Tugas**: tambah tugas lewat dialog isian, centang tugas yang selesai, dan hapus tugas.
- **Statistik**: ringkasan jumlah tugas selesai, persentase progres, jumlah tugas tersisa, dan rincian tugas hari ini. Angkanya ikut berubah saat data tugas berubah.
- **Tentang**: informasi aplikasi dan pembuat.

## Tampilan
<img width="267" height="554" alt="gambar" src="https://github.com/user-attachments/assets/30f830ef-5a43-44ae-88c9-cc5a46f91df9" />
<img width="259" height="547" alt="gambar" src="https://github.com/user-attachments/assets/8d388141-1eed-4670-b72b-52ee391d5e0e" />
<img width="254" height="545" alt="gambar" src="https://github.com/user-attachments/assets/075a4dd8-ac44-4e72-b8d4-913e03a33023" />

## Teknologi

- Flutter (Material Design 3)
- Dart
- Tanpa paket tambahan: seluruh tampilan memakai widget bawaan Flutter

## Struktur proyek

```
lib/
├── main.dart                    # Aplikasi, model data, gaya teks, navigasi
├── welcome_page.dart            # Halaman penyambutan
├── tugas_page.dart              # Halaman Tugas dan dialog tambah tugas
└── statistik_tentang_page.dart  # Halaman Statistik dan Tentang
assets/
└── images/
    └── ikon_catatan.png         # Logo aplikasi
```

## Konsep yang diterapkan

| Konsep | Penerapan |
|---|---|
| Teks dengan font dan styling | Kelas `GayaTeks` di `main.dart` |
| Input dan event handling | `TextField` dengan `onChanged` dan `onSubmitted` pada dialog tambah tugas, serta event ketuk, hapus, dan pindah halaman |
| Asset gambar dan ikon | `Image.asset` untuk logo dan `Icon` bawaan Material |
| Pengelolaan state | `StatefulWidget` dan `setState` pada `HomePage` |
| Navigasi | `NavigationBar` dan `Navigator` |
| Daftar dinamis | `ListView.builder` |
| Progres | `LinearProgressIndicator` |

## Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi stable terbaru)
- Salah satu perangkat untuk menjalankan aplikasi:
  - Google Chrome atau Windows desktop (tidak membutuhkan Android SDK)
  - Emulator atau HP Android (membutuhkan Android SDK)

Cek instalasi dengan:

```
flutter doctor
```

## Cara menjalankan

1. Clone repository:

   ```
   git clone https://github.com/yukinagano23/uts_framework_mobile.git
   cd uts_framework_mobile
   ```

2. Unduh dependensi:

   ```
   flutter pub get
   ```

3. Jalankan aplikasi:

   ```
   flutter run -d chrome
   ```

   Pilihan perangkat lain:

   ```
   flutter run -d windows
   flutter devices          # melihat daftar perangkat, termasuk HP
   flutter run -d <id-perangkat>
   ```

Saat aplikasi berjalan, tekan `r` di terminal untuk *hot reload*, `R` untuk *hot restart*, dan `q` untuk berhenti.

## Membuat file APK (opsional)

Membutuhkan Android SDK.

```
flutter build apk
```

Hasilnya ada di `build/app/outputs/flutter-apk/app-release.apk`.

## Keterbatasan

- Data tugas hanya tersimpan selama aplikasi berjalan dan hilang saat aplikasi ditutup.
- Kartu **Rentetan Hari** di halaman Statistik masih berisi data contoh dan belum dihitung dari aktivitas pengguna.

## Rencana pengembangan

- Penyimpanan data permanen (misalnya dengan `shared_preferences`)
- Rentetan hari yang dihitung dari aktivitas sungguhan
- Tenggat waktu dan pengingat tugas
- Pilihan tema gelap

## Pembuat

**Yuki Nagano**

© 2026 Hak Cipta Dilindungi
