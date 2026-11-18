import 'package:flutter/material.dart';

import 'main.dart';

// ====================================================
// HALAMAN PENYAMBUTAN
// Tampil pertama kali saat aplikasi dibuka. Berisi logo
// (asset gambar), nama aplikasi, deskripsi singkat, dan
// tombol "Mulai" yang membuka halaman Tugas.
// ====================================================
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // Event: pindah ke HomePage dengan efek memudar.
  // pushReplacement dipakai agar tombol "kembali" di HP tidak
  // membawa pengguna ke halaman penyambutan lagi.
  void _mulai(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Logo + nama + deskripsi, muncul perlahan
            const _MunculPelan(
              child: Column(
                children: [
                  _LogoBerlingkar(),
                  SizedBox(height: 26),
                  Text(
                    'Catatan Tugas',
                    style: TextStyle(
                      fontFamily: kFont,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: kTeks,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Catat, pantau, dan selesaikan tugas harianmu '
                      'dengan mudah.',
                      textAlign: TextAlign.center,
                      style: GayaTeks.isi,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Tombol Mulai
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () => _mulai(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: kBiru,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: kFont,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Mulai'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Versi 1.0', style: GayaTeks.keterangan),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// Logo di dalam dua lingkaran biru muda
// ----------------------------------------------------
class _LogoBerlingkar extends StatelessWidget {
  const _LogoBerlingkar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 196,
      height: 196,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kBiruPucat,
      ),
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: kBiruMuda,
          ),
          child: Center(
            child: Image.asset(
              kLogoAsset,
              width: 104,
              height: 104,
              fit: BoxFit.contain,
              // Jika gambar belum terpasang, tampilkan ikon pengganti
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.checklist,
                size: 64,
                color: kBiruTua,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// Efek muncul perlahan: memudar masuk sambil naik sedikit.
// TweenAnimationBuilder berjalan sendiri tanpa controller.
// ----------------------------------------------------
class _MunculPelan extends StatelessWidget {
  final Widget child;

  const _MunculPelan({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (context, nilai, anak) {
        return Opacity(
          opacity: nilai,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - nilai)),
            child: anak,
          ),
        );
      },
      child: child,
    );
  }
}
