
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../data/menu_repository.dart';


class MenuDetailScreen extends StatefulWidget {
  final MenuItem item;
  final double diskon;
  const MenuDetailScreen({super.key, required this.item, this.diskon = 0.3});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.item.rating;
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return 'Rp${buffer.toString()}';
  }


  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final diskon = widget.diskon;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: const Color(0xFFb71c1c),
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item.imageAsset,
                  width: 220,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 220,
                    height: 160,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(item.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFb71c1c))),
            const SizedBox(height: 8),
            Text(item.desc, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 16),
            if (diskon > 0 && diskon < 1) ...[
              Text('Harga Asli: ${_formatRupiah(item.price)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                  )),
              Text('Harga Diskon: ${_formatRupiah((item.price * (1 - diskon)).round())}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFb71c1c),
                    fontWeight: FontWeight.bold,
                  )),
              Text('Diskon ${((diskon) * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  )),
            ] else ...[
              Text('Harga: ${_formatRupiah(item.price)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFb71c1c),
                    fontWeight: FontWeight.bold,
                  )),
            ],
            const SizedBox(height: 18),
            Text('Rating Menu', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 8),
            Text('Rating saat ini: ${_rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 15)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFb71c1c),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Pesan Sekarang'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pesanan Berhasil'),
                      content: Text('Anda telah memesan ${item.name}.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
