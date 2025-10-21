import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Future<bool> login(String email, String password) {
    return service.login(email, password);
  }

  Future<void> logout() => service.logout();
  Future<bool> isLoggedIn() => service.isLoggedIn();
  Future<String?> getEmail() => service.getEmail();
  Future<bool> register(String email, String password) => service.register(email, password);
  Future<List<Map<String, dynamic>>> getUsers() => service.getUsers();
  Future<bool> addUser(String email, String password, {bool verified = false}) => service.addUser(email, password, verified: verified);
  Future<bool> updateUser(String originalEmail, {String? email, String? password, bool? verified}) => service.updateUser(originalEmail, email: email, password: password, verified: verified);
  Future<bool> deleteUser(String email) => service.deleteUser(email);
  Future<bool> setVerified(String email, bool verified) => service.setVerified(email, verified);
  Future<bool> isVerified(String email) => service.isVerified(email);
}