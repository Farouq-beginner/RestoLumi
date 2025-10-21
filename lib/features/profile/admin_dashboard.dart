import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../../data/repositories/auth_repository.dart';
import 'restaurant_settings_screen.dart';
import 'terms_and_permissions_screen.dart';
import 'manage_users_screen.dart';

String formatRupiah(num value) {
  final s = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return 'Rp${buffer.toString()}';
}

class AdminDashboard extends StatefulWidget {
  final AuthRepository repository;
  final String adminEmail;
  const AdminDashboard({super.key, required this.repository, required this.adminEmail});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late final ValueNotifier<Future<List<Map<String, dynamic>>>> _usersFutureVN;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _adminVerifiedVN = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _usersFutureVN = ValueNotifier(widget.repository.getUsers());
    _loadAdminVerified();
  }
  // Reload helper removed (no direct references)

  Future<void> _loadAdminVerified() async {
    final v = await widget.repository.isVerified(widget.adminEmail);
    if (!mounted) return;
    _adminVerifiedVN.value = v;
  }

  Future<void> _toggleAdminVerified() async {
    final next = !_adminVerifiedVN.value;
    final ok = await widget.repository.setVerified(widget.adminEmail, next);
    if (!mounted) return;
    if (ok) {
      _adminVerifiedVN.value = next;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next ? 'Verifikasi admin diaktifkan' : 'Verifikasi admin dinonaktifkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah status verifikasi admin')),
      );
    }
  }

  // Note: Penambahan pengguna kini dipindahkan ke halaman Kelola Users


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _adminVerifiedVN,
            builder: (context, adminVerified, _) => IconButton(
              tooltip: adminVerified ? 'Nonaktifkan verifikasi' : 'Aktifkan verifikasi',
              onPressed: _toggleAdminVerified,
              icon: Icon(
                adminVerified ? Icons.verified : Icons.verified_outlined,
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<Future<List<Map<String, dynamic>>>>(
        valueListenable: _usersFutureVN,
        builder: (context, fut, __) => FutureBuilder<List<Map<String, dynamic>>>(
          future: fut,
          builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final adminName = widget.adminEmail.contains('@')
              ? widget.adminEmail.split('@').first
              : (widget.adminEmail.isNotEmpty ? widget.adminEmail : 'Admin');

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar & Info seperti di dashboard profil
                Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _adminVerifiedVN,
                    builder: (context, adminVerified, ___) {
                      final avatar = ClipOval(
                        child: SizedBox(
                          width: 96,
                          height: 96,
                          child: Image.asset(
                            'assets/images/profile.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Text(
                                  adminName.isNotEmpty ? adminName[0].toUpperCase() : 'A',
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                      if (adminVerified) {
                        return badges.Badge(
                          badgeContent: const Icon(Icons.check, color: Colors.white, size: 16),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.instagram,
                            badgeColor: Colors.lightBlueAccent,
                            padding: const EdgeInsets.all(6),
                          ),
                          position: badges.BadgePosition.topEnd(top: -2, end: -2),
                          child: avatar,
                        );
                      }
                      return avatar;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Nama:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(adminName),
                const SizedBox(height: 8),
                const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.adminEmail),
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
                          Text(formatRupiah(1573000000), style: const TextStyle(fontSize: 18)),
                        ]),
                        Column(children: [
                          const Text('Pendapatan', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(formatRupiah(6000000), style: const TextStyle(fontSize: 18)),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol masuk ke halaman Kelola Users
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ManageUsersScreen(
                            repository: widget.repository,
                            adminEmail: widget.adminEmail,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.group),
                    label: const Text('Kelola Users'),
                  ),
                ),
                const SizedBox(height: 16),
                //belum nambah fitur
                const SizedBox(height: 24),
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
                            url: 'https://policies.google.com/',
                          ),
                        ),
                      );
                    },
                    child: const Text('View Privacy & Terms'),
                  ),
                ),
              ],
            ),
          );
          },
        ),
      ),
    );
  }
}
