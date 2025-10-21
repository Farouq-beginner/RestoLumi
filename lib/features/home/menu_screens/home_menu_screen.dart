import 'package:flutter/material.dart';
import 'menu_detail_screen.dart';
import '../widgets/search_sort.dart';
import '../data/menu_repository.dart';

class HomeMenuScreen extends StatefulWidget {
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
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  List<MenuItem> _allMenu = const [];
  bool _loading = true;
  late ValueNotifier<List<Map<String, dynamic>>> _filteredMenuNotifier;
  late SearchSortController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SearchSortController();
    _filteredMenuNotifier = ValueNotifier<List<Map<String, dynamic>>>([]);
    _controller.searchQuery.addListener(_filterAndSort);
    _controller.sortBy.addListener(_filterAndSort);
    _load();
  }

  Future<void> _load() async {
    final repo = MenuRepository();
    final all = await repo.getSpecials();
    setState(() {
      _allMenu = all;
  _filteredMenuNotifier = ValueNotifier<List<Map<String, dynamic>>>(
        all
            .map((e) => {
                  'name': e.name,
                  'desc': e.desc,
                  'price': e.price,
                  'icon': e.iconData,
                  'type': e.type,
                  'image': e.imageAsset,
                  'category': e.category,
                  'rating': e.rating,
                })
            .toList(),
      );
      _loading = false;
    });
  }

  @override
  void dispose() {
    _filteredMenuNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _filterAndSort() {
    final mapped = _allMenu
        .map((e) => {
              'name': e.name,
              'price': e.price,
              'desc': e.desc,
              'icon': e.iconData,
              'type': e.type,
              'image': e.imageAsset,
              'category': e.category,
              'rating': e.rating,
            })
        .toList();
    _filteredMenuNotifier.value = filterAndSort<Map<String, dynamic>>(
      all: mapped,
      query: _controller.searchQuery.value,
      sortBy: _controller.sortBy.value,
      nameOf: (m) => m['name'] as String,
      priceOf: (m) => m['price'] as int,
    );
  }

  @override
  Widget build(BuildContext context) {
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
    body: _loading
      ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          // Search + Sort (reusable)
          SearchSortBar(controller: _controller, hintText: 'Cari menu spesial...'),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: _filteredMenuNotifier,
              builder: (context, menus, child) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  children: [
                    ...menus.map(
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
                                color: const Color(0xFFb71c1c),
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
                                    if (widget.showDiscount) ...[
                                      Text(
                                        widget.formatRupiah(menu['price'] as int),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        widget.formatRupiah(((menu['price'] as int) * (1 - widget.diskon)).round()),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFb71c1c),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ] else ...[
                                      Text(
                                        widget.formatRupiah(menu['price'] as int),
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
                                  // Option A: keep existing MenuDetailScreen but pass image from data
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MenuDetailScreen(
                                        item: MenuItem(
                                          name: menu['name'] as String,
                                          desc: menu['desc'] as String,
                                          price: menu['price'] as int,
                                          iconName: 'custom',
                                          type: menu['type'] as String,
                                          category: menu['category'] as String,
                                          imageAsset: (menu['image'] as String?) ?? 'assets/images/home.png',
                                          rating: (menu['rating'] as num?)?.toDouble() ?? 4.0,
                                        ),
                                        diskon: widget.showDiscount ? widget.diskon : 0.0,
                                      ),
                                    ),
                                  );
                                  // Option B: switch to generic MenuItemDetailScreen for consistency
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (_) => MenuItemDetailScreen(
                                  //       item: MenuItem(
                                  //         name: menu['name'] as String,
                                  //         desc: menu['desc'] as String,
                                  //         price: menu['price'] as int,
                                  //         iconName: 'custom',
                                  //         type: menu['type'] as String,
                                  //         category: menu['category'] as String,
                                  //         imageAsset: (menu['image'] as String?) ?? 'assets/images/home.png',
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );
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
