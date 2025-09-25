import 'package:flutter/material.dart';
import 'menu_detail_screen.dart';

class HomeMenuScreen extends StatelessWidget {
  final bool showDiscount;
  final String Function(int) formatRupiah;
  final void Function(String) onOrder;
  final double diskon;

  const HomeMenuScreen({
    super.key,
    this.diskon = 0.3,
    required this.showDiscount,
    required this.formatRupiah,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    final menuList = [
      {
        'name': 'Nasi Goreng Spesial',
        'desc': 'Nasi goreng dengan topping ayam, telur, dan kerupuk.',
        'price': 25000,
        'icon': Icons.rice_bowl,
        'image': 'assets/images/nasi_goreng.png',
      },
      {
        'name': 'Steak Daging Premium',
        'desc': 'Steak daging sapi impor, saus lada hitam.',
        'price': 75000,
        'icon': Icons.set_meal,
        'image': 'assets/images/steak.png',
      },
      {
        'name': 'Es Teh Manis Jumbo',
        'desc': 'Minuman segar ukuran besar.',
        'price': 8000,
        'icon': Icons.emoji_food_beverage,
        'image': 'assets/images/es_teh.png',
      },
      {
        'name': 'Paket Hemat Berdua',
        'desc': '2 Nasi + 2 Ayam + 2 Minum, cocok untuk berdua.',
        'price': 45000,
        'icon': Icons.fastfood,
        'image': 'assets/images/paket_hemat.png',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
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
          ...menuList.map(
            (menu) => Card(
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
                      menu['icon'] as IconData,
                      color: Color(0xFFb71c1c),
                      size: 38,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu['name'] as String,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFb71c1c),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            menu['desc'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (showDiscount) ...[
                            Text(
                              formatRupiah(menu['price'] as int),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black38,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              formatRupiah(((menu['price'] as int) * (1 - diskon)).round()),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFFb71c1c),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else ...[
                            Text(
                              formatRupiah(menu['price'] as int),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
                            builder: (_) => MenuDetailScreen(
                              name: menu['name'] as String,
                              desc: menu['desc'] as String,
                              price: menu['price'] as int,
                              imageAsset: menu['image'] as String,
                              diskon: showDiscount ? diskon : 0.0,
                            ),
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
