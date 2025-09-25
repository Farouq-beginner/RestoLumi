import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _sizeAnim = Tween<double>(begin: 270, end: 48).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      context.read<SplashCubit>().startSplash();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAnimating) {
          _controller.forward();
        } else if (state is SplashFinished) {
          widget.onFinish();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _sizeAnim,
                builder: (context, child) => CircleAvatar(
                  radius: _sizeAnim.value,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.restaurant,
                    color: const Color(0xFFb71c1c),
                    size: _sizeAnim.value,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Restaurant Lumière',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFb71c1c),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Dibuat oleh:',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              const Text(
                'Farouq Gusmo Abdilah',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> startSplash() async {
    emit(SplashAnimating());
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashFinished());
  }
}

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashAnimating extends SplashState {}

class SplashFinished extends SplashState {}
