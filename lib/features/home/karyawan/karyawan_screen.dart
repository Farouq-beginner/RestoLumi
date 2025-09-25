// karyawan_page.dart
import 'package:flutter/material.dart';
import '../karyawan/models/karyawan_model.dart';
import 'karyawan_detail_screen.dart';

class KaryawanPage extends StatelessWidget {
  final List<Karyawan> daftarKaryawan = [
    KaryawanTetap(1, "Andi", 5000000, 2000000),
    KaryawanKontrak(2, "Budi", 3000000, 12),
    KaryawanTetap(3, "Citra", 6000000, 2500000),
    KaryawanKontrak(4, "Dewi", 2800000, 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Karyawan")),
      body: ListView.builder(
        itemCount: daftarKaryawan.length,
        itemBuilder: (context, index) {
          final karyawan = daftarKaryawan[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(karyawan.nama[0]),
              ),
              title: Text(karyawan.nama,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(karyawan.getInfo()),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => KaryawanDetailScreen(karyawan: karyawan),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
