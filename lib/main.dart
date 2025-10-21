import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/services/auth_service.dart';
import 'data/repositories/auth_repository.dart';
import 'features/auth/bloc/login_cubit.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/profile/terms_and_permissions_screen.dart';
import 'features/auth/bloc/register_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

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

      // 🟢 Tambahan untuk mendukung berbagai bahasa
      supportedLocales: const [
        Locale('id'), // Indonesia
        Locale('en'), // English
        Locale('fr'), // French
        Locale('ja'), // Japanese
        Locale('de'), // German
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },

      // 🧭 Routing system (dipertahankan)
      onGenerateRoute: (settings) {
        if (settings.name == '/' || settings.name == true) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => SplashCubit(),
              child: SplashScreen(
                onFinish: () async {
                  final loggedIn = await repository.isLoggedIn();
                  if (!context.mounted) return;
                  if (loggedIn) {
                    final email = await repository.getEmail();
                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(email: email),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
              ),
            ),
          );
        } else if (settings.name == '/login') {
          final args = settings.arguments;
          String? prefillEmail;
          if (args is Map && args['email'] is String?) {
            prefillEmail = args['email'] as String?;
          }
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => LoginCubit(repository),
              child: LoginScreen(prefillEmail: prefillEmail),
            ),
          );
        } else if (settings.name == '/register') {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => RegisterCubit(repository),
              child: const RegisterScreen(),
            ),
          );
        } else if (settings.name == '/home') {
          // Route guard untuk memastikan user benar-benar login di semua platform (termasuk web)
          return MaterialPageRoute(
            builder: (context) => FutureBuilder<bool>(
              future: repository.isLoggedIn(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snap.data != true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  });
                  return const SizedBox.shrink();
                }
                return FutureBuilder<String?>(
                  future: repository.getEmail(),
                  builder: (context, emailSnap) {
                    final email = emailSnap.data;
                    return HomeScreen(email: email);
                  },
                );
              },
            ),
          );
        } else if (settings.name == '/terms') {
          return MaterialPageRoute(
            builder: (_) => const TermsAndPermissionsScreen(
              url: 'https://policies.google.com/terms',
            ),
          );
        }

        // fallback ke Splash jika route tidak ditemukan
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
