import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginCubit(this.repository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final success = await repository.login(email, password);
      if (success) {
        emit(LoginSuccess());
      } else {
        emit(const LoginFailure("Email atau password salah"));
      }
    } catch (e) {
      emit(LoginFailure("Error: $e"));
    }
  }
}