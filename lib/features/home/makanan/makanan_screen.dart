import 'package:flutter/material.dart';
import '../widgets/search_sort.dart';
import '../data/menu_repository.dart';
import '../widgets/menu_item_detail_screen.dart';

class MakananPage extends StatefulWidget {
  const MakananPage({super.key});

  @override
  State<MakananPage> createState() => _MakananPageState();
}

class _MakananPageState extends State<MakananPage> {
  List<MenuItem> _allMakanan = const [];
  late ValueNotifier<List<MenuItem>> _filteredMakananNotifier;
  late SearchSortController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = SearchSortController();
    _filteredMakananNotifier = ValueNotifier<List<MenuItem>>([]);
    _controller.searchQuery.addListener(_filterAndSort);
    _controller.sortBy.addListener(_filterAndSort);
    _load();
  }

  @override
  void dispose() {
    _filteredMakananNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = MenuRepository();
    final data = await repo.getByCategory('makanan');
    _allMakanan = data;
    _loading = false;
    _filterAndSort();
    if (mounted) setState(() {});
  }

  void _filterAndSort() {
    _filteredMakananNotifier.value = filterAndSort<MenuItem>(
      all: _allMakanan,
      query: _controller.searchQuery.value,
      sortBy: _controller.sortBy.value,
      nameOf: (m) => m.name,
      priceOf: (m) => m.price,
    );
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
          // Search + Sort (reusable)
          SearchSortBar(controller: _controller, hintText: 'Cari makanan...'),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ValueListenableBuilder<List<MenuItem>>(
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
                                makanan.iconData,
                                color: Color(0xFFb71c1c),
                                size: 38,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      makanan.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFb71c1c),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      makanan.desc.isNotEmpty ? makanan.desc : 'Lezat dan bergizi.',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatRupiah(makanan.price),
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
                                      builder: (_) => MenuItemDetailScreen(item: makanan),
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
