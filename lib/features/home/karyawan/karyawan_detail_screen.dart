import 'package:flutter/material.dart';
import 'models/karyawan_model.dart';

class KaryawanDetailScreen extends StatelessWidget {
  final Karyawan karyawan;
  const KaryawanDetailScreen({Key? key, required this.karyawan}) : super(key: key);

  String formatRupiah(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Karyawan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(karyawan.nama[0], style: TextStyle(fontSize: 28)),
            ),
            SizedBox(height: 24),
            Text('ID: ${karyawan.id}', style: TextStyle(fontSize: 18)),
            Text('Nama: ${karyawan.nama}', style: TextStyle(fontSize: 18)),
            Text('Gaji: ${formatRupiah(karyawan.gaji as int)}', style: TextStyle(fontSize: 18)),
            if (karyawan is KaryawanTetap)
              Text('Tunjangan: ${formatRupiah((karyawan as KaryawanTetap).tunjangan as int)}', style: TextStyle(fontSize: 18)),
            if (karyawan is KaryawanKontrak)
              Text('Durasi Kontrak: ${(karyawan as KaryawanKontrak).durasiKontrak} bulan', style: TextStyle(fontSize: 18)),
            SizedBox(height: 32),
            Text('Info:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(karyawan.getInfo(), style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
