import 'package:flutter/material.dart';
import 'model/makanan_model.dart';
import 'makanan_detail_screen.dart';

class MakananPage extends StatefulWidget {
  MakananPage({Key? key}) : super(key: key);

  @override
  State<MakananPage> createState() => _MakananPageState();
}

class _MakananPageState extends State<MakananPage> {
  final List<Makanan> _allMakanan = [
    MakananBerkuah(1, 'Soto Ayam', 18000, adaKuah: true),
    MakananBerkuah(2, 'Bakso', 20000, adaKuah: true),
    MakananKering(3, 'Nasi Goreng', 17000, 'Kering'),
    MakananKering(4, 'Ayam Goreng', 22000, 'Renyah'),
    MakananBerkuah(5, 'Mie Kuah', 15000, adaKuah: true),
    MakananKering(6, 'Tempe Goreng', 8000, 'Kering'),
  ];

  late ValueNotifier<List<Makanan>> _filteredMakananNotifier;
  late ValueNotifier<String> _searchQueryNotifier;
  late ValueNotifier<String> _sortByNotifier;

  @override
  void initState() {
    super.initState();
    _searchQueryNotifier = ValueNotifier<String>('');
    _sortByNotifier = ValueNotifier<String>('nama');
    _filteredMakananNotifier = ValueNotifier<List<Makanan>>(
      List.from(_allMakanan),
    );

    // Listen to changes and update filtered list
    _searchQueryNotifier.addListener(_filterAndSort);
    _sortByNotifier.addListener(_filterAndSort);
  }

  @override
  void dispose() {
    _filteredMakananNotifier.dispose();
    _searchQueryNotifier.dispose();
    _sortByNotifier.dispose();
    super.dispose();
  }

  void _filterAndSort() {
    // Filter berdasarkan search query
    List<Makanan> filtered = _allMakanan.where((makanan) {
      return makanan.nama.toLowerCase().contains(
        _searchQueryNotifier.value.toLowerCase(),
      );
    }).toList();

    // Sort berdasarkan pilihan
    if (_sortByNotifier.value == 'nama') {
      filtered.sort((a, b) => a.nama.compareTo(b.nama));
    } else if (_sortByNotifier.value == 'harga_asc') {
      filtered.sort((a, b) => a.harga.compareTo(b.harga));
    } else if (_sortByNotifier.value == 'harga_desc') {
      filtered.sort((a, b) => b.harga.compareTo(a.harga));
    }

    _filteredMakananNotifier.value = filtered;
  }

  IconData getMakananIcon(String nama) {
    final lower = nama.toLowerCase();
    if (lower.contains('soto') ||
        lower.contains('mie') ||
        lower.contains('bakso')) {
      return Icons.ramen_dining;
    } else if (lower.contains('nasi')) {
      return Icons.rice_bowl;
    } else if (lower.contains('ayam')) {
      return Icons.set_meal;
    } else if (lower.contains('tempe')) {
      return Icons.fastfood;
    } else {
      return Icons.restaurant_menu;
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Makanan'),
        backgroundColor: const Color(0xFFb71c1c),
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari makanan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _searchQueryNotifier.value = value;
              },
            ),
          ),
          // Sort Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  'Urutkan: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _sortByNotifier,
                  builder: (context, sortBy, child) {
                    return DropdownButton<String>(
                      value: sortBy,
                      items: const [
                        DropdownMenuItem(value: 'nama', child: Text('Nama')),
                        DropdownMenuItem(
                          value: 'harga_asc',
                          child: Text('Harga (Murah ke Mahal)'),
                        ),
                        DropdownMenuItem(
                          value: 'harga_desc',
                          child: Text('Harga (Mahal ke Murah)'),
                        ),
                      ],
                      onChanged: (value) {
                        _sortByNotifier.value = value ?? 'nama';
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // List Makanan
          Expanded(
            child: ValueListenableBuilder<List<Makanan>>(
              valueListenable: _filteredMakananNotifier,
              builder: (context, filteredMakanan, child) {
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  children: [
                    ...filteredMakanan.map(
                      (makanan) => Card(
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
                                getMakananIcon(makanan.nama),
                                color: Color(0xFFb71c1c),
                                size: 38,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      makanan.nama,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFb71c1c),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      makanan.getInfo(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatRupiah(makanan.harga.toInt()),
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
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MakananDetailScreen(makanan: makanan),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
