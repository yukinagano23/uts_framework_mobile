import 'package:flutter/material.dart';

import 'main.dart';

// ====================================================
// FILE 3 dari 3: HALAMAN STATISTIK dan HALAMAN TENTANG
// ====================================================

// ====================================================
// HALAMAN STATISTIK
// Membaca daftar tugas yang sama dengan halaman Tugas,
// sehingga angkanya selalu ikut berubah.
// ====================================================
class StatistikPage extends StatelessWidget {
  final List<Tugas> daftar;
  final VoidCallback onLihatSemua;

  const StatistikPage({
    super.key,
    required this.daftar,
    required this.onLihatSemua,
  });

  String _judulProgres(int total, int persen) {
    if (total == 0) return 'Belum Ada Tugas';
    if (persen == 100) return 'Target Tercapai!';
    return 'Progres Berjalan Baik';
  }

  String _deskripsi(int total, int selesai, int sisa) {
    if (total == 0) return 'Tambahkan tugas di tab Tugas untuk mulai.';
    if (sisa == 0) return 'Hebat! Semua tugas hari ini sudah kamu selesaikan.';
    if (selesai == 0) return 'Ayo mulai dari satu tugas kecil hari ini!';
    return 'Kamu sudah memulai langkah awal dengan baik. '
        'Selesaikan $sisa tugas tersisa hari ini!';
  }

  @override
  Widget build(BuildContext context) {
    final total = daftar.length;
    final selesai = daftar.where((t) => t.selesai).length;
    final sisa = total - selesai;
    final progres = total == 0 ? 0.0 : selesai / total;
    final persen = (progres * 100).round();
    // Sisa jam sampai tengah malam
    final jamTersisa = 24 - DateTime.now().hour;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        // --- Judul bagian ---
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('RINGKASAN HARI INI',
                      style: GayaTeks.labelKecil),
                  const SizedBox(height: 2),
                  Text(
                    _judulProgres(total, persen),
                    style: GayaTeks.judulBagian,
                  ),
                ],
              ),
            ),
            const _Pil(
              ikon: Icons.bolt,
              teks: 'Fokus',
              warna: kBiruMuda,
              warnaIkon: kBiruTua,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // --- Kartu utama ---
        _KartuUtama(
          selesai: selesai,
          total: total,
          persen: persen,
          progres: progres,
          deskripsi: _deskripsi(total, selesai, sisa),
          jamTersisa: jamTersisa,
        ),
        const SizedBox(height: 16),

        // --- Dua kartu kecil ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _KartuMini(
                label: 'Belum Selesai',
                nilai: '$sisa',
                keterangan: 'Tugas menanti',
                ikon: Icons.pending_actions,
                warnaLingkaran: kAbuLingkaran,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: _KartuMini(
                label: 'Rentetan Hari',
                nilai: '4 Hari',
                keterangan: 'Konsistensi aktif',
                ikon: Icons.local_fire_department,
                warnaLingkaran: kBiruMuda,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // --- Rincian hari ini ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rincian Hari Ini',
              style: TextStyle(
                fontFamily: kFont,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kTeks,
              ),
            ),
            // Event: pindah ke tab Tugas
            TextButton(
              onPressed: onLihatSemua,
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontFamily: kFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kBiru,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (daftar.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Belum ada tugas.', style: GayaTeks.isi),
          )
        else
          // Maksimal 3 tugas pertama
          for (final tugas in daftar.take(3)) _BarisRincian(tugas: tugas),
      ],
    );
  }
}

// Label kecil berbentuk pil (dipakai di judul bagian)
class _Pil extends StatelessWidget {
  final IconData? ikon;
  final String teks;
  final Color warna;
  final Color warnaIkon;

  const _Pil({
    this.ikon,
    required this.teks,
    required this.warna,
    required this.warnaIkon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ikon != null) ...[
            Icon(ikon, size: 16, color: warnaIkon),
            const SizedBox(width: 4),
          ],
          Text(
            teks,
            style: const TextStyle(
              fontFamily: kFont,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kTeksAbu,
            ),
          ),
        ],
      ),
    );
  }
}

// Kartu besar berisi ringkasan dan bar progres
class _KartuUtama extends StatelessWidget {
  final int selesai;
  final int total;
  final int persen;
  final double progres;
  final String deskripsi;
  final int jamTersisa;

  const _KartuUtama({
    required this.selesai,
    required this.total,
    required this.persen,
    required this.progres,
    required this.deskripsi,
    required this.jamTersisa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: kBiruMuda,
            child: Icon(Icons.trending_up, size: 30, color: kBiruTua),
          ),
          const SizedBox(height: 16),
          Text(
            '$selesai dari $total tugas selesai',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: kFont,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: kTeks,
            ),
          ),
          const SizedBox(height: 8),
          Text(deskripsi, textAlign: TextAlign.center, style: GayaTeks.isi),
          const SizedBox(height: 24),

          // LinearProgressIndicator: bar progres
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progres,
              minHeight: 10,
              color: kBiru,
              backgroundColor: const Color(0xFFE6E1E1),
            ),
          ),
          const SizedBox(height: 20),

          // Angka persen besar
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$persen', style: GayaTeks.angkaBesar),
              const SizedBox(width: 4),
              const Text(
                '%',
                style: TextStyle(
                  fontFamily: kFont,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kBiru,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Tercapai dari target harian',
              style: GayaTeks.keterangan),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: kKartu,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.schedule, size: 16, color: kBiruTua),
                const SizedBox(width: 6),
                Text(
                  'Tersisa $jamTersisa jam lagi',
                  style: const TextStyle(
                    fontFamily: kFont,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kTeks,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Kartu kecil untuk satu angka ringkasan
class _KartuMini extends StatelessWidget {
  final String label;
  final String nilai;
  final String keterangan;
  final IconData ikon;
  final Color warnaLingkaran;

  const _KartuMini({
    required this.label,
    required this.nilai,
    required this.keterangan,
    required this.ikon,
    required this.warnaLingkaran,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kKartu,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: kFont,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kTeksAbu,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              CircleAvatar(
                radius: 17,
                backgroundColor: warnaLingkaran,
                child: Icon(ikon, size: 18, color: kBiruTua),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            nilai,
            style: const TextStyle(
              fontFamily: kFont,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: kTeks,
            ),
          ),
          const SizedBox(height: 2),
          Text(keterangan, style: GayaTeks.keterangan),
        ],
      ),
    );
  }
}

// Satu baris pada "Rincian Hari Ini"
class _BarisRincian extends StatelessWidget {
  final Tugas tugas;

  const _BarisRincian({required this.tugas});

  @override
  Widget build(BuildContext context) {
    final selesai = tugas.selesai;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selesai ? kBiru : kAbuLingkaran,
            ),
            child: selesai
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tugas.judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: kFont,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: selesai ? kTeksAbu : kTeks,
                    decoration: selesai ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tugas.subjudul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GayaTeks.keterangan,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Label status di sisi kanan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: selesai ? kBiruMuda : kKartu,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selesai ? 'Selesai' : 'Menunggu',
              style: TextStyle(
                fontFamily: kFont,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selesai ? kBiruTua : kTeksAbu,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// HALAMAN TENTANG
// Informasi aplikasi. Tombol bagikan menampilkan SnackBar
// sebagai contoh event handling.
// ====================================================
class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  void _bagikan(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur bagikan belum tersedia di versi 1.0'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tombol bagikan di kanan atas
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
            child: IconButton(
              icon: const Icon(Icons.share_outlined),
              color: kTeks,
              tooltip: 'Bagikan',
              onPressed: () => _bagikan(context),
            ),
          ),
        ),

        // Bagian tengah (bisa digulir jika layar pendek)
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _LogoUtama(),
                  const SizedBox(height: 22),
                  const Text(
                    'Catatan Tugas',
                    style: TextStyle(
                      fontFamily: kFont,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: kTeks,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _Pil(
                    teks: 'Versi 1.0',
                    warna: kBiruMuda,
                    warnaIkon: kBiruTua,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kKartu,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Aplikasi sederhana untuk mencatat tugas harian, '
                      'dibuat dengan Flutter.',
                      textAlign: TextAlign.center,
                      style: GayaTeks.isi.copyWith(fontSize: 15, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _ChipFitur(ikon: Icons.bolt, teks: 'Cepat'),
                      _ChipFitur(
                          ikon: Icons.offline_pin_outlined, teks: 'Offline'),
                      _ChipFitur(ikon: Icons.shield, teks: 'Aman'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bagian bawah: pembuat dan hak cipta
        const Padding(
          padding: EdgeInsets.only(top: 12, bottom: 28),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 20, color: kBiru),
                  SizedBox(width: 6),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: kFont,
                        fontSize: 15,
                        color: kTeksAbu,
                      ),
                      children: [
                        TextSpan(text: 'Dibuat oleh: '),
                        TextSpan(
                          text: 'Yuki Nagano',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: kTeks,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                '© 2026 Hak Cipta Dilindungi',
                style: TextStyle(
                  fontFamily: kFont,
                  fontSize: 13,
                  letterSpacing: 0.5,
                  color: kTeksAbu,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Lingkaran biru besar dengan tanda centang dan lencana kecil
class _LogoUtama extends StatelessWidget {
  const _LogoUtama();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kBiruTua,
              boxShadow: [
                BoxShadow(
                  color: Color(0x330B57D0),
                  blurRadius: 36,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 60,
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.verified_outlined,
                  size: 20, color: kBiruTua),
            ),
          ),
        ],
      ),
    );
  }
}

// Label fitur berbentuk pil abu-abu
class _ChipFitur extends StatelessWidget {
  final IconData ikon;
  final String teks;

  const _ChipFitur({required this.ikon, required this.teks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: kKartu,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 17, color: kTeksAbu),
          const SizedBox(width: 6),
          Text(
            teks,
            style: const TextStyle(
              fontFamily: kFont,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kTeksAbu,
            ),
          ),
        ],
      ),
    );
  }
}
