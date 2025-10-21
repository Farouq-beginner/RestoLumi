import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository repository;

  RegisterCubit(this.repository) : super(RegisterInitial());

  Future<void> register(String email, String password) async {
    emit(RegisterLoading());
    try {
      final ok = await repository.register(email, password);
      if (ok) {
        emit(RegisterSuccess());
      } else {
        emit(const RegisterFailure('Registrasi gagal'));
      }
    } catch (e) {
      emit(RegisterFailure('Error: $e'));
    }
  }
}
