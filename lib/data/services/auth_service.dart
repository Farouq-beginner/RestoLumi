class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == "Farouq@gmail.com" && password == "12345") {
      return true;
    }
    return false;
  }
}