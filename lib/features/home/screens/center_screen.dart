import 'package:flutter/material.dart';
import 'package:my_project/features/home/menu_screens/home_menu_screen.dart';
import 'package:my_project/features/home/minuman/minuman_screen.dart';
import '../karyawan/karyawan_screen.dart';
import '../makanan/makanan_screen.dart';

class CenterScreen extends StatelessWidget {
  const CenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 350,
          height: 56,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFb71c1c),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.menu_book, size: 28),
            label: const Text('Lihat Daftar Menu Spesial'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HomeMenuScreen(
                    showDiscount: true,
                    formatRupiah: (value) {
                      final s = value.toString();
                      final buffer = StringBuffer();
                      for (int i = 0; i < s.length; i++) {
                        if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
                        buffer.write(s[i]);
                      }
                      return 'Rp${buffer.toString()}';
                    },
                    onOrder: (menuName) {
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 350,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFb71c1c),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.local_drink, size: 24),
            label: const Text('Lihat Daftar Minuman'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MinumanPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 350,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFb71c1c),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.rice_bowl, size: 24),
            label: const Text('Lihat Daftar Makanan'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MakananPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 350,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFb71c1c),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.people, size: 24),
            label: const Text('Lihat Daftar Karyawan'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => KaryawanPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
