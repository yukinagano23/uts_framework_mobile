import 'package:flutter/material.dart';

import 'statistik_tentang_page.dart';
import 'tugas_page.dart';
import 'welcome_page.dart';

// ====================================================
// APLIKASI "CATATAN TUGAS"
//
// Daftar file:
//   main.dart                    -> aplikasi, model data, gaya teks, navigasi
//   welcome_page.dart            -> halaman penyambutan
//   tugas_page.dart              -> halaman Tugas
//   statistik_tentang_page.dart  -> halaman Statistik & Tentang
// ====================================================

// ---------- Warna ----------
const Color kBiru = Color(0xFF0B57D0);
const Color kBiruTua = Color(0xFF003EA6);
const Color kBiruMuda = Color(0xFFD7E3FB);
const Color kBiruPucat = Color(0xFFE6ECFB);
const Color kLatar = Color(0xFFFCF8F8);
const Color kKartu = Color(0xFFF4F2F2);
const Color kAbuLingkaran = Color(0xFFE6E4E4);
const Color kTeks = Color(0xFF1B1B1F);
const Color kTeksAbu = Color(0xFF44474E);

// ---------- Font & aset gambar ----------
// Font bawaan Flutter/Android. Ganti nama font di sini
// untuk mengubah font di seluruh aplikasi.
const String kFont = 'Roboto';
const String kLogoAsset = 'assets/images/ikon_catatan.png';

// ====================================================
// 1. GAYA TEKS (pilihan font + styling)
// Semua teks di aplikasi memakai gaya dari kelas ini.
// ====================================================
class GayaTeks {
  static const TextStyle judulAppBar = TextStyle(
    fontFamily: kFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: kTeks,
  );

  // Teks kecil huruf kapital dengan jarak antarhuruf
  static const TextStyle labelKecil = TextStyle(
    fontFamily: kFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
    color: kTeksAbu,
  );

  static const TextStyle judulBagian = TextStyle(
    fontFamily: kFont,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: kTeks,
  );

  static const TextStyle judulKartu = TextStyle(
    fontFamily: kFont,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: kTeks,
  );

  static const TextStyle keterangan = TextStyle(
    fontFamily: kFont,
    fontSize: 13,
    color: kTeksAbu,
  );

  static const TextStyle isi = TextStyle(
    fontFamily: kFont,
    fontSize: 14,
    height: 1.5,
    color: kTeksAbu,
  );

  static const TextStyle angkaBesar = TextStyle(
    fontFamily: kFont,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1,
    color: kBiruTua,
  );
}

// ====================================================
// 2. MODEL DATA
// Menyimpan informasi untuk setiap tugas.
// ====================================================
class Tugas {
  String judul;
  String keterangan;
  bool selesai;

  Tugas(this.judul, this.keterangan, {this.selesai = false});

  // Teks di bawah judul. Tugas selesai diberi awalan "Selesai".
  String get subjudul => selesai ? 'Selesai • $keterangan' : keterangan;
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan Tugas',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: kFont,
        colorScheme: ColorScheme.fromSeed(seedColor: kBiru),
        scaffoldBackgroundColor: kLatar,
        // Tema menu bawah: label tab aktif berwarna biru dan tebal
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: kKartu,
          surfaceTintColor: Colors.transparent,
          indicatorColor: kBiruMuda,
          indicatorShape: const StadiumBorder(),
          height: 80,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final aktif = states.contains(WidgetState.selected);
            return TextStyle(
              fontFamily: kFont,
              fontSize: 12,
              fontWeight: aktif ? FontWeight.w700 : FontWeight.w500,
              color: aktif ? kBiru : kTeksAbu,
            );
          }),
        ),
      ),
      // Halaman pertama yang tampil: penyambutan, lalu HomePage
      home: const WelcomePage(),
    );
  }
}

// ====================================================
// 3. HALAMAN INDUK (StatefulWidget)
// Menyimpan data tugas di satu tempat (state terpusat),
// lalu membagikannya ke halaman Tugas dan Statistik.
// ====================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Tab aktif: 0 = Tugas, 1 = Statistik, 2 = Tentang
  int _tabAktif = 0;

  final List<String> _judulTab = ['Tugas', 'Statistik', 'Tentang'];

  // Data awal (sesuai desain)
  final List<Tugas> _daftar = [
    Tugas('Belajar Flutter', 'Pengembangan Mobile • Mandiri'),
    Tugas('Kerjakan tugas pertemuan 7', 'Praktikum Pemrograman',
        selesai: true),
    Tugas('Siapkan presentasi', 'Besok, 09:00 • Desain Antarmuka'),
  ];

  // Setiap perubahan data dibungkus setState agar tampilan digambar ulang.
  void _tambah(Tugas tugas) => setState(() => _daftar.add(tugas));

  void _toggle(int index) {
    setState(() => _daftar[index].selesai = !_daftar[index].selesai);
  }

  void _hapus(int index) => setState(() => _daftar.removeAt(index));

  void _keTabTugas() => setState(() => _tabAktif = 0);

  @override
  Widget build(BuildContext context) {
    final halaman = [
      TugasPage(
        daftar: _daftar,
        onTambah: _tambah,
        onToggle: _toggle,
        onHapus: _hapus,
      ),
      StatistikPage(daftar: _daftar, onLihatSemua: _keTabTugas),
      const TentangPage(),
    ];

    return Scaffold(
      // AppBar: logo (asset gambar) di kiri nama halaman
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: kBiruMuda,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset(
              kLogoAsset,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              // Jika gambar belum terpasang, tampilkan ikon pengganti
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.checklist, color: kBiruTua, size: 32),
            ),
            const SizedBox(width: 12),
            Text(_judulTab[_tabAktif], style: GayaTeks.judulAppBar),
          ],
        ),
      ),
      body: halaman[_tabAktif],

      // NavigationBar: menu navigasi di bagian bawah
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabAktif,
        onDestinationSelected: (index) => setState(() => _tabAktif = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_box_outlined),
            selectedIcon: Icon(Icons.check_box, color: kBiruTua),
            label: 'Tugas',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            selectedIcon: Icon(Icons.bar_chart, color: kBiruTua),
            label: 'Statistik',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info, color: kBiruTua),
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}