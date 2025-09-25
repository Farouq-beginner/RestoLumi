class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == "farouq@gmail.com" && password == "12345") {
      return true;
    }
    return false;
  }
}