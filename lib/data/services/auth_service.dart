import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class AuthService {
  static const _tokenKey = 'token';
  static const _emailKey = 'email';
  static const _usersKey = 'users'; // simpan daftar user terdaftar (demo)
  static const _verifiedMapKey = 'verified_map'; // simpan status verifikasi untuk email yang tidak ada di daftar users

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    final e = email.trim();
    final p = password;

    // 1) Akun hardcoded untuk demo tetap didukung
    final hardcoded = (e == "Farouq@gmail.com" && p == "12345");

    // 2) Cek akun yang pernah didaftarkan
    final usersJson = prefs.getString(_usersKey);
    bool inRegistered = false;
    if (usersJson != null && usersJson.isNotEmpty) {
      try {
        final list = (jsonDecode(usersJson) as List)
            .cast<Map<String, dynamic>>();
        inRegistered = list.any((u) =>
            (u['email'] as String).toLowerCase().trim() == e.toLowerCase().trim() &&
            (u['password'] as String) == p);
      } catch (_) {}
    }

    if (hardcoded || inRegistered) {
      final token = const Uuid().v4();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_emailKey, e);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
  }

  // Registrasi: simpan akun ke daftar user lokal (demo), TIDAK auto-login
  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    final e = email.trim();
    final p = password;

    List<Map<String, dynamic>> users = [];
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null && usersJson.isNotEmpty) {
      try {
        users = (jsonDecode(usersJson) as List).cast<Map<String, dynamic>>();
      } catch (_) {
        users = [];
      }
    }

    final exists = users.any((u) =>
        (u['email'] as String).toLowerCase().trim() == e.toLowerCase().trim());
    if (exists) {
      return false; // email sudah terdaftar
    }

    users.add({
      'email': e,
      'password': p, // NOTE: plaintext hanya untuk demo!
      'verified': false,
    });
    await prefs.setString(_usersKey, jsonEncode(users));
    return true;
  }

  // ====== Manajemen Pengguna (Demo Lokal) ======
  Future<List<Map<String, dynamic>>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null || usersJson.isEmpty) return [];
    try {
      return (jsonDecode(usersJson) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<bool> addUser(String email, String password, {bool verified = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    final e = email.trim();
    if (users.any((u) => (u['email'] as String).toLowerCase().trim() == e.toLowerCase().trim())) {
      return false;
    }
    users.add({'email': e, 'password': password, 'verified': verified});
    await prefs.setString(_usersKey, jsonEncode(users));
    return true;
  }

  Future<bool> updateUser(String originalEmail, {String? email, String? password, bool? verified}) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    final idx = users.indexWhere((u) => (u['email'] as String).toLowerCase().trim() == originalEmail.toLowerCase().trim());
    if (idx < 0) return false;
    final updated = Map<String, dynamic>.from(users[idx]);
    if (email != null) updated['email'] = email.trim();
    if (password != null) updated['password'] = password;
    if (verified != null) updated['verified'] = verified;
    users[idx] = updated;
    await prefs.setString(_usersKey, jsonEncode(users));
    return true;
  }

  Future<bool> deleteUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    users.removeWhere((u) => (u['email'] as String).toLowerCase().trim() == email.toLowerCase().trim());
    await prefs.setString(_usersKey, jsonEncode(users));
    return true;
  }

  Future<bool> setVerified(String email, bool verified) async {
    // Coba update pada daftar users terlebih dahulu
    final updated = await updateUser(email, verified: verified);
    if (updated) return true;

    // Jika email tidak ditemukan di daftar users (mis. admin hardcoded), simpan ke verified_map
    final prefs = await SharedPreferences.getInstance();
    final map = await _loadVerifiedMap(prefs);
    map[email.toLowerCase().trim()] = verified;
    await _saveVerifiedMap(prefs, map);
    return true;
  }

  Future<bool> isVerified(String email) async {
    final lower = email.toLowerCase().trim();

    // 1) Cek di daftar users
    final users = await getUsers();
    final u = users.firstWhere(
      (e) => (e['email'] as String).toLowerCase().trim() == lower,
      orElse: () => {},
    );
    if (u.isNotEmpty) {
      return (u['verified'] as bool?) ?? false;
    }

    // 2) Cek di verified_map (untuk akun seperti admin hardcoded)
    final prefs = await SharedPreferences.getInstance();
    final map = await _loadVerifiedMap(prefs);
    if (map.containsKey(lower)) {
      return map[lower] ?? false;
    }

    // 3) Default: admin terverifikasi
    if (lower == 'farouq@gmail.com') {
      return true;
    }

    return false;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final email = prefs.getString(_emailKey);
    // Anggap valid hanya jika token dan email tersedia (hindari status "guest" saat token tersisa tanpa identitas)
    return token != null && email != null && email.isNotEmpty;
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // ====== Helpers untuk verified_map ======
  Future<Map<String, bool>> _loadVerifiedMap(SharedPreferences prefs) async {
    final raw = prefs.getString(_verifiedMapKey);
    if (raw == null || raw.isEmpty) return <String, bool>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return decoded.map<String, bool>((key, value) => MapEntry(key.toString(), value == true));
      }
      return <String, bool>{};
    } catch (_) {
      return <String, bool>{};
    }
  }

  Future<void> _saveVerifiedMap(SharedPreferences prefs, Map<String, bool> map) async {
    await prefs.setString(_verifiedMapKey, jsonEncode(map));
  }
}