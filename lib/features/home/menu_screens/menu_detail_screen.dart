import 'package:flutter/material.dart';

class MenuDetailScreen extends StatelessWidget {
  final String name;
  final String desc;
  final int price;
  final String imageAsset;
  final double diskon;

  const MenuDetailScreen({
    Key? key,
    required this.name,
    required this.desc,
    required this.price,
    required this.imageAsset,
    this.diskon = 0.3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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
                  imageAsset,
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
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFb71c1c))),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 16),
            if (diskon > 0 && diskon < 1) ...[
              Text('Harga Asli: Rp$price',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                  )),
              Text('Harga Diskon: Rp${(price * (1 - diskon)).round()}',
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
              Text('Harga: Rp$price',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFb71c1c),
                    fontWeight: FontWeight.bold,
                  )),
            ],
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
                      content: Text('Anda telah memesan $name.'),
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
