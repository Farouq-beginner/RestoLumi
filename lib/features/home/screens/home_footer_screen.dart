import 'package:flutter/material.dart';

class HomeFooterScreen extends StatelessWidget {
  const HomeFooterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: const Text(
            'Terima kasih sudah mencoba aplikasi ini. Jangan lupa beri rating 100 di PlayStore! 🍽️',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFb71c1c),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '© 2025 Restaurant Lumière',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
