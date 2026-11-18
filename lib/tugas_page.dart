import 'package:flutter/material.dart';

import 'main.dart';

// ====================================================
// FILE 2 dari 3: HALAMAN TUGAS
// Memakai ListView.builder, InkWell (event ketuk),
// AlertDialog + TextField (input), dan FloatingActionButton.
// ====================================================
class TugasPage extends StatelessWidget {
  final List<Tugas> daftar;
  final void Function(Tugas) onTambah;
  final void Function(int) onToggle;
  final void Function(int) onHapus;

  const TugasPage({
    super.key,
    required this.daftar,
    required this.onTambah,
    required this.onToggle,
    required this.onHapus,
  });

  // Membuka dialog input, lalu menambahkan hasilnya ke daftar
  Future<void> _bukaDialogTambah(BuildContext context) async {
    final hasil = await showDialog<Tugas>(
      context: context,
      builder: (_) => const _DialogTambahTugas(),
    );
    if (hasil != null) onTambah(hasil);
  }

  @override
  Widget build(BuildContext context) {
    final total = daftar.length;
    final selesai = daftar.where((t) => t.selesai).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tombol + diletakkan di sudut kanan bawah, tepat di atas ikon
        // tanda seru (tab Tentang). Ikon itu berada di tengah sepertiga
        // lebar layar paling kanan, jadi jaraknya dari tepi kanan adalah
        // (lebar / 6) dikurangi setengah lebar tombol (56 / 2 = 28).
        final kananFab =
            (constraints.maxWidth / 6 - 28).clamp(16.0, 120.0).toDouble();

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: _Ringkasan(selesai: selesai, total: total),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: _ChipSemua(),
                ),
                Expanded(
                  child: total == 0
                      ? const _DaftarKosong()
                      : ListView.builder(
                          // Ruang di bawah agar tombol + tidak menutupi item
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                          itemCount: total + 1,
                          itemBuilder: (context, i) {
                            // Item terakhir adalah kartu semangat
                            if (i == total) {
                              return _BannerSemangat(
                                selesai: selesai,
                                total: total,
                              );
                            }
                            return _KartuTugas(
                              tugas: daftar[i],
                              onToggle: () => onToggle(i),
                              onHapus: () => onHapus(i),
                            );
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              right: kananFab,
              bottom: 20,
              child: FloatingActionButton(
                heroTag: 'fab_tambah',
                onPressed: () => _bukaDialogTambah(context),
                backgroundColor: kBiru,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.add, size: 30),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ----------------------------------------------------
// Bagian judul: "PRIORITAS HARI INI" + penghitung selesai
// ----------------------------------------------------
class _Ringkasan extends StatelessWidget {
  final int selesai;
  final int total;

  const _Ringkasan({required this.selesai, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PRIORITAS HARI INI', style: GayaTeks.labelKecil),
              SizedBox(height: 2),
              Text('Fokus & Produktif', style: GayaTeks.judulBagian),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: kBiruMuda,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 18, color: kBiruTua),
              const SizedBox(width: 6),
              Text(
                '$selesai dari $total selesai',
                style: const TextStyle(
                  fontFamily: kFont,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kTeks,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------
// Chip filter "Semua" (chip "Hari Ini" dan "Kuliah" dihapus)
// ----------------------------------------------------
class _ChipSemua extends StatelessWidget {
  const _ChipSemua();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: kBiruMuda,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.all_inclusive, size: 18, color: kBiruTua),
          SizedBox(width: 6),
          Text(
            'Semua',
            style: TextStyle(
              fontFamily: kFont,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kTeksAbu,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// Kartu satu tugas. Ketuk kartu = centang/batal centang.
// ----------------------------------------------------
class _KartuTugas extends StatelessWidget {
  final Tugas tugas;
  final VoidCallback onToggle;
  final VoidCallback onHapus;

  const _KartuTugas({
    required this.tugas,
    required this.onToggle,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    final selesai = tugas.selesai;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: kKartu,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
            child: Row(
              children: [
                // Lingkaran status: abu-abu = belum, biru + centang = selesai
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selesai ? kBiru : kAbuLingkaran,
                  ),
                  child: selesai
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tugas.judul,
                        style: GayaTeks.judulKartu.copyWith(
                          color: selesai ? kTeksAbu : kTeks,
                          decoration:
                              selesai ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(tugas.subjudul, style: GayaTeks.keterangan),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: kTeksAbu,
                  tooltip: 'Hapus tugas',
                  onPressed: onHapus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// Kartu semangat di bawah daftar. Teksnya mengikuti data.
// ----------------------------------------------------
class _BannerSemangat extends StatelessWidget {
  final int selesai;
  final int total;

  const _BannerSemangat({required this.selesai, required this.total});

  @override
  Widget build(BuildContext context) {
    final sisa = total - selesai;
    final judul = sisa == 0 ? 'Luar biasa!' : 'Langkah bagus!';
    final isi = sisa == 0
        ? 'Semua tugas hari ini sudah selesai.'
        : 'Selesaikan $sisa tugas lagi untuk menuntaskan target hari ini.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBiruPucat,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: kBiruMuda,
            child: Icon(Icons.celebration_outlined, color: kBiruTua, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontFamily: kFont,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kTeks,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GayaTeks.isi.copyWith(color: kTeks),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DaftarKosong extends StatelessWidget {
  const _DaftarKosong();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Belum ada tugas.\nTekan tombol + untuk menambah.',
        textAlign: TextAlign.center,
        style: GayaTeks.isi,
      ),
    );
  }
}

// ====================================================
// DIALOG INPUT TUGAS BARU
// Event handling: onChanged (mengaktifkan tombol Simpan),
// onSubmitted (Enter = simpan), dan onPressed (tombol).
// Dibuat sebagai StatefulWidget agar controller bisa dibuang
// (dispose) dengan benar.
// ====================================================
class _DialogTambahTugas extends StatefulWidget {
  const _DialogTambahTugas();

  @override
  State<_DialogTambahTugas> createState() => _DialogTambahTugasState();
}

class _DialogTambahTugasState extends State<_DialogTambahTugas> {
  final TextEditingController _judulCtrl = TextEditingController();
  final TextEditingController _ketCtrl = TextEditingController();
  bool _bolehSimpan = false;

  @override
  void dispose() {
    _judulCtrl.dispose();
    _ketCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    final judul = _judulCtrl.text.trim();
    if (judul.isEmpty) return;

    final ket = _ketCtrl.text.trim();
    // Mengirim tugas baru kembali ke pemanggil dialog
    Navigator.pop(
      context,
      Tugas(judul, ket.isEmpty ? 'Tanpa keterangan' : ket),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tugas baru', style: GayaTeks.judulBagian),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _judulCtrl,
              autofocus: true,
              textInputAction: TextInputAction.next,
              // Dipanggil setiap kali teks berubah
              onChanged: (teks) {
                setState(() => _bolehSimpan = teks.trim().isNotEmpty);
              },
              decoration: const InputDecoration(
                labelText: 'Judul tugas',
                hintText: 'Mis. Belajar Flutter',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ketCtrl,
              textInputAction: TextInputAction.done,
              // Dipanggil saat pengguna menekan Enter
              onSubmitted: (_) => _simpan(),
              decoration: const InputDecoration(
                labelText: 'Keterangan (opsional)',
                hintText: 'Mis. Desain Antarmuka',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kBiru),
          // null = tombol nonaktif selama judul masih kosong
          onPressed: _bolehSimpan ? _simpan : null,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
