import 'package:flutter/material.dart';
import 'model/makanan_model.dart';

class MakananDetailScreen extends StatelessWidget {
  final Makanan makanan;
  const MakananDetailScreen({Key? key, required this.makanan}) : super(key: key);

  String formatRupiah(int value) {
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
    final imageAsset = 'assets/images/${makanan.nama.toLowerCase().replaceAll(' ', '_')}.png';
    return Scaffold(
      appBar: AppBar(
        title: Text(makanan.nama),
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
            Text(makanan.nama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFb71c1c))),
            const SizedBox(height: 8),
            Text(makanan.getInfo(), style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 16),
            Text('Harga: ${formatRupiah(makanan.harga.toInt())}', style: const TextStyle(fontSize: 20, color: Color(0xFFb71c1c), fontWeight: FontWeight.bold)),
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
                      content: Text('Anda telah memesan ${makanan.nama}.'),
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
