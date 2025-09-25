import 'package:flutter/material.dart';
import 'home_menu_screen.dart';

class MenuScreen extends StatelessWidget {
  final bool showDiscount;
  final String Function(int) formatRupiah;
  final void Function(String) onOrder;

  const MenuScreen({
    super.key,
    required this.showDiscount,
    required this.formatRupiah,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
        backgroundColor: const Color(0xFFb71c1c),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: HomeMenuScreen(
            showDiscount: showDiscount,
            formatRupiah: formatRupiah,
            onOrder: onOrder,
          ),
        ),
      ),
    );
  }
}