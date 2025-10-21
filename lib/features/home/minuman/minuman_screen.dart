import 'package:flutter/material.dart';
import '../widgets/search_sort.dart';
import '../data/menu_repository.dart';
import '../widgets/menu_item_detail_screen.dart';

class MinumanPage extends StatefulWidget {
  const MinumanPage({super.key});

  @override
  State<MinumanPage> createState() => _MinumanPageState();
}

class _MinumanPageState extends State<MinumanPage> {
  List<MenuItem> _allMinuman = const [];
  late ValueNotifier<List<MenuItem>> _filteredMinumanNotifier;
  late SearchSortController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = SearchSortController();
    _filteredMinumanNotifier = ValueNotifier<List<MenuItem>>([]);
    _controller.searchQuery.addListener(_filterAndSort);
    _controller.sortBy.addListener(_filterAndSort);
    _load();
  }

  @override
  void dispose() {
    _filteredMinumanNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _filterAndSort() {
    _filteredMinumanNotifier.value = filterAndSort<MenuItem>(
      all: _allMinuman,
      query: _controller.searchQuery.value,
      sortBy: _controller.sortBy.value,
      nameOf: (m) => m.name,
      priceOf: (m) => m.price,
    );
  }

  Future<void> _load() async {
    final repo = MenuRepository();
    final data = await repo.getByCategory('minuman');
    _allMinuman = data;
    _loading = false;
    _filterAndSort();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Minuman"),
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
          SearchSortBar(controller: _controller, hintText: 'Cari minuman...'),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ValueListenableBuilder<List<MenuItem>>(
                    valueListenable: _filteredMinumanNotifier,
                    builder: (context, list, child) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        children: [
                          ...list.map(
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
                                      minuman.iconData,
                                      color: const Color(0xFFb71c1c),
                                      size: 38,
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            minuman.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFb71c1c),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            minuman.desc.isNotEmpty
                                                ? minuman.desc
                                                : 'Segar dan nikmat.',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Rp${minuman.price.toStringAsFixed(0)}',
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
                                        backgroundColor: const Color(
                                          0xFFb71c1c,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                MenuItemDetailScreen(
                                                  item: minuman,
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
