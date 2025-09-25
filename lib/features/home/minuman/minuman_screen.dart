import 'package:flutter/material.dart';
import '../minuman/model/minuman_model.dart';
import 'minuman_detail_screen.dart';

class MinumanPage extends StatelessWidget {
  IconData getMinumanIcon(String nama) {
    final lower = nama.toLowerCase();
    if (lower.contains('teh')) {
      return Icons.emoji_food_beverage;
    } else if (lower.contains('jeruk')) {
      return Icons.local_drink;
    } else if (lower.contains('kopi')) {
      return Icons.coffee;
    } else {
      return Icons.local_cafe;
    }
  }

  final List<Minuman> daftarMinuman = [
    MinumanDingin(1, "Es Teh", 5000),
    MinumanDingin(2, "Es Jeruk", 7000, adaEs: true),
    MinumanPanas(3, "Kopi Panas", 10000, 70),
    MinumanPanas(4, "Teh Panas", 6000, 65),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Minuman"),
        backgroundColor: const Color(0xFFb71c1c),
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        children: [
          ...daftarMinuman.map(
            (minuman) => Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      getMinumanIcon(minuman.nama),
                      color: Color(0xFFb71c1c),
                      size: 38,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            minuman.nama,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFb71c1c),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            minuman.getInfo(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp${minuman.harga.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFb71c1c),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFb71c1c),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                MinumanDetailScreen(minuman: minuman),
                          ),
                        );
                      },
                      child: const Text('Pesan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
