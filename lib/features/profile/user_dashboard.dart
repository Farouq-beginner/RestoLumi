import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'restaurant_settings_screen.dart';
import 'terms_and_permissions_screen.dart';

String formatRupiah(num value) {
  final s = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return 'Rp${buffer.toString()}';
}

class UserDashboard extends StatelessWidget {
  final String name;
  final String email;
  final double saldo;
  final double pendapatan;
  final List<Map<String, dynamic>> riwayatPesanan;
  final bool isVerified; // untuk tampilkan centang di avatar user jika diverifikasi admin

  const UserDashboard({
    super.key,
    required this.name,
    required this.email,
    required this.saldo,
    required this.pendapatan,
    required this.riwayatPesanan,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Pengguna')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: isVerified
                  ? badges.Badge(
                      badgeContent: const Icon(Icons.check, color: Colors.white, size: 16),
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.instagram,
                        badgeColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.all(6),
                      ),
                      position: badges.BadgePosition.topEnd(top: -2, end: -2),
                      child: _InitialAvatar(name: name.isNotEmpty ? name : (email.isNotEmpty ? email : '')),
                    )
                  : _InitialAvatar(name: name.isNotEmpty ? name : (email.isNotEmpty ? email : '')),
            ),
            const SizedBox(height: 16),
            const Text('Nama:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(name),
            const SizedBox(height: 8),
            const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(email),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      const Text('Saldo', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatRupiah(saldo), style: const TextStyle(fontSize: 18)),
                    ]),
                    Column(children: [
                      const Text('Pendapatan', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatRupiah(pendapatan), style: const TextStyle(fontSize: 18)),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Riwayat Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            riwayatPesanan.isEmpty
                ? const Text('Belum ada pesanan.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: riwayatPesanan.length,
                    itemBuilder: (context, index) {
                      final pesanan = riwayatPesanan[index];
                      return Card(
                        child: ListTile(
                          title: Text(pesanan['menu'] ?? '-'),
                          subtitle: Text('Tanggal: ${pesanan['tanggal'] ?? '-'}'),
                          trailing: Text(formatRupiah(pesanan['total'] ?? 0)),
                        ),
                      );
                    },
                  ),
              const SizedBox(height: 24),
              // Pengaturan Restoran
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.orange),
                  title: const Text('Pengaturan Restoran'),
                  subtitle: const Text('Atur tanggal, waktu, dan format internasional'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RestaurantSettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsAndPermissionsScreen(
                          url: 'https://policies.google.com/terms',
                        ),
                      ),
                    );
                  },
                  child: const Text('View Terms & Permissions'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String name;
  const _InitialAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = (name.isNotEmpty ? name.trim()[0] : '?').toUpperCase();
    return ClipOval(
      child: Container(
        width: 96,
        height: 96,
        color: Colors.grey[300],
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
