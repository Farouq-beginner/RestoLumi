import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/services/auth_service.dart';
import 'data/repositories/auth_repository.dart';
import 'features/auth/bloc/login_cubit.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/splash_screen.dart';

void main() {
  final authRepository = AuthRepository(AuthService());
  runApp(MyApp(repository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Lumière',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/' || settings.name == null) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => SplashCubit(),
              child: SplashScreen(
                onFinish: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ),
          );
        } else if (settings.name == '/login') {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => LoginCubit(repository),
              child: const LoginScreen(),
            ),
          );
        } else if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          );
        }
        // fallback
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => SplashCubit(),
            child: SplashScreen(
              onFinish: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
        );
      },
    );
  }
}
