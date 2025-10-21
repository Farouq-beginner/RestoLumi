import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../../data/repositories/auth_repository.dart';

class ManageUsersScreen extends StatefulWidget {
  final AuthRepository repository;
  final String adminEmail;
  const ManageUsersScreen({super.key, required this.repository, required this.adminEmail});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late final ValueNotifier<Future<List<Map<String, dynamic>>>> _usersFutureVN;

  @override
  void initState() {
    super.initState();
    _usersFutureVN = ValueNotifier(widget.repository.getUsers());
  }

  void _reload() {
    _usersFutureVN.value = widget.repository.getUsers();
  }

  Future<void> _addUserDialog() async {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final verifiedVN = ValueNotifier<bool>(false);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Pengguna'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 8),
            ValueListenableBuilder<bool>(
              valueListenable: verifiedVN,
              builder: (context, verified, _) => Row(
                children: [
                  Checkbox(value: verified, onChanged: (v) => verifiedVN.value = v ?? false),
                  const Text('Verifikasi (centang biru)'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simpan')),
        ],
      ),
    );
    if (ok == true) {
      final success = await widget.repository.addUser(emailCtrl.text, passCtrl.text, verified: verifiedVN.value);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Pengguna ditambahkan' : 'Email sudah terdaftar')),
      );
      _reload();
    }
  }

  Future<void> _editUserDialog(Map<String, dynamic> user) async {
    final emailCtrl = TextEditingController(text: user['email'] as String? ?? '');
    final passCtrl = TextEditingController(text: user['password'] as String? ?? '');
    final verifiedVN = ValueNotifier<bool>((user['verified'] as bool?) ?? false);
    final originalEmail = user['email'] as String? ?? '';
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Pengguna'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 8),
            ValueListenableBuilder<bool>(
              valueListenable: verifiedVN,
              builder: (context, verified, _) => Row(
                children: [
                  Checkbox(value: verified, onChanged: (v) => verifiedVN.value = v ?? false),
                  const Text('Verifikasi (centang biru)')
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simpan')),
        ],
      ),
    );
    if (ok == true) {
      final success = await widget.repository.updateUser(
        originalEmail,
        email: emailCtrl.text,
        password: passCtrl.text,
        verified: verifiedVN.value,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Pengguna diperbarui' : 'Gagal memperbarui pengguna')),
      );
      _reload();
    }
  }

  Future<void> _deleteUser(String email) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Pengguna'),
        content: Text('Yakin hapus $email?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) {
      await widget.repository.deleteUser(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengguna dihapus')),
      );
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Users')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUserDialog,
        child: const Icon(Icons.person_add),
      ),
      body: ValueListenableBuilder<Future<List<Map<String, dynamic>>>>(
        valueListenable: _usersFutureVN,
        builder: (context, usersFuture, _) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: usersFuture,
            builder: (context, snap) {
              final users = snap.data ?? [];
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (users.isEmpty) {
                return const Center(child: Text('Belum ada pengguna.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, i) {
                  final u = users[i];
                  final email = u['email'] as String? ?? '';
                  final verified = (u['verified'] as bool?) ?? false;
                  final isSelf = email.toLowerCase().trim() == widget.adminEmail.toLowerCase().trim();
                  return ListTile(
                    leading: verified
                        ? badges.Badge(
                            badgeContent: const Icon(Icons.check, size: 12, color: Colors.white),
                            badgeStyle: badges.BadgeStyle(
                              shape: badges.BadgeShape.instagram,
                              badgeColor: Colors.lightBlueAccent,
                              padding: const EdgeInsets.all(4),
                            ),
                            position: badges.BadgePosition.topEnd(top: -2, end: -2),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Text(email.isNotEmpty ? email[0].toUpperCase() : '?'),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: Text(email.isNotEmpty ? email[0].toUpperCase() : '?'),
                          ),
                    title: Text(email),
                    subtitle: Text(verified ? 'Terverifikasi' : 'Belum terverifikasi'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          tooltip: 'Edit',
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editUserDialog(u),
                        ),
                        IconButton(
                          tooltip: 'Hapus',
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: isSelf ? null : () => _deleteUser(email),
                        ),
                        IconButton(
                          tooltip: verified ? 'Cabut verifikasi' : 'Verifikasi',
                          onPressed: () async {
                            await widget.repository.setVerified(email, !verified);
                            _reload();
                          },
                          icon: badges.Badge(
                            badgeContent: const Icon(Icons.check, size: 10, color: Colors.white),
                            badgeStyle: badges.BadgeStyle(
                              shape: badges.BadgeShape.instagram,
                              badgeColor: verified ? Colors.lightBlueAccent : Colors.grey,
                              padding: const EdgeInsets.all(5),
                            ),
                            position: badges.BadgePosition.topEnd(top: 0, end: 0),
                            child: const SizedBox(width: 18, height: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: users.length,
              );
            },
          );
        },
      ),
    );
  }
}
