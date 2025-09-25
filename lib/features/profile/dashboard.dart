import 'package:flutter/material.dart';

String formatRupiah(num value) {
  final s = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return 'Rp${buffer.toString()}';
}

class ProfileDashboard extends StatelessWidget {
  final String name;
  final String email;
  final double saldo;
  final double pendapatan;
  final List<Map<String, dynamic>> riwayatPesanan;

  const ProfileDashboard({
    Key? key,
    required this.name,
    required this.email,
    required this.saldo,
    required this.pendapatan,
    required this.riwayatPesanan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Restoran')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipOval(
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter, // Fokus bagian atas gambar
                    height: 50, // Hanya bagian atas yang terlihat jika gambar potrait
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0] : '',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nama:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(name),
            const SizedBox(height: 8),
            Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(email),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Saldo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatRupiah(saldo),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Pendapatan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatRupiah(pendapatan),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Riwayat Pesanan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            riwayatPesanan.isEmpty
                ? Text('Belum ada pesanan.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: riwayatPesanan.length,
                    itemBuilder: (context, index) {
                      final pesanan = riwayatPesanan[index];
                      return Card(
                        child: ListTile(
                          title: Text(pesanan['menu'] ?? '-'),
                          subtitle: Text(
                            'Tanggal: ${pesanan['tanggal'] ?? '-'}',
                          ),
                          trailing: Text(formatRupiah(pesanan['total'] ?? 0)),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 24),
            // Tambahkan fitur lain di bawah ini
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Pengaturan Restoran'),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
