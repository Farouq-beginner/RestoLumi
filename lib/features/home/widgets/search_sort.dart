import 'package:flutter/material.dart';

/// Controller to manage search query and sort option
class SearchSortController {
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  final ValueNotifier<String> sortBy = ValueNotifier<String>('nama');

  void dispose() {
    searchQuery.dispose();
    sortBy.dispose();
  }
}

/// Reusable search + sort bar used across menu pages
class SearchSortBar extends StatelessWidget {
  final SearchSortController controller;
  final String hintText;

  const SearchSortBar({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (v) => controller.searchQuery.value = v,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text('Urutkan: ', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              ValueListenableBuilder<String>(
                valueListenable: controller.sortBy,
                builder: (context, sortBy, child) {
                  return DropdownButton<String>(
                    value: sortBy,
                    items: const [
                      DropdownMenuItem(value: 'nama', child: Text('Nama')),
                      DropdownMenuItem(value: 'harga_asc', child: Text('Harga (Murah ke Mahal)')),
                      DropdownMenuItem(value: 'harga_desc', child: Text('Harga (Mahal ke Murah)')),
                    ],
                    onChanged: (v) => controller.sortBy.value = v ?? 'nama',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Generic filter and sort helper for list of items.
/// - nameOf: returns the comparable name string
/// - priceOf: returns the comparable numeric price
List<T> filterAndSort<T>({
  required List<T> all,
  required String query,
  required String sortBy,
  required String Function(T) nameOf,
  required num Function(T) priceOf,
}) {
  final q = query.toLowerCase();
  final filtered = all.where((e) => nameOf(e).toLowerCase().contains(q)).toList();

  switch (sortBy) {
    case 'harga_asc':
      filtered.sort((a, b) => priceOf(a).compareTo(priceOf(b)));
      break;
    case 'harga_desc':
      filtered.sort((a, b) => priceOf(b).compareTo(priceOf(a)));
      break;
    case 'nama':
    default:
      filtered.sort((a, b) => nameOf(a).compareTo(nameOf(b)));
      break;
  }
  return filtered;
}
