import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';


class MenuItem {
  final String name;
  final String desc;
  final int price;
  final String iconName;
  final String type;
  final String category;
  final String imageAsset;
  final double rating;

  const MenuItem({
    required this.name,
    required this.desc,
    required this.price,
    required this.iconName,
    required this.type,
    required this.category,
    required this.imageAsset,
    required this.rating,
  });

  IconData get iconData => _mapIcon(iconName);

  static IconData _mapIcon(String name) {
    switch (name) {
      case 'rice_bowl':
        return Icons.rice_bowl;
      case 'set_meal':
        return Icons.set_meal;
      case 'emoji_food_beverage':
        return Icons.emoji_food_beverage;
      case 'fastfood':
        return Icons.fastfood;
      case 'local_drink':
        return Icons.local_drink;
      default:
        return Icons.restaurant_menu;
    }
  }
}

class MenuRepository {
  static const _assetPath = 'assets/data.json';

  Future<List<MenuItem>> getAll() async {
    final raw = await rootBundle.loadString(_assetPath);
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) {
      final map = e as Map<String, dynamic>;
      final name = (map['name'] as String?) ?? '';
      final icon = (map['icon'] as String?) ?? '';
      final category = ((map['category'] as String?) ?? '').toLowerCase().trim();
      final type = category.isNotEmpty
          ? (category == 'minuman'
              ? 'minuman'
              : category == 'makanan'
                  ? 'makanan'
                  : _inferType(name, icon))
          : _inferType(name, icon);
      final image = (map['image'] as String?)?.trim();
      return MenuItem(
        name: name,
        desc: (map['desc'] as String?) ?? '',
        price: (map['price'] as num?)?.toInt() ?? 0,
        iconName: icon,
        type: type,
        category: category.isNotEmpty ? category : type,
        imageAsset: (image != null && image.isNotEmpty)
            ? image
            : 'assets/images/home.png',
        rating: (map['rating'] as num?)?.toDouble() ?? 4.0,
      );
    }).toList();
  }

  Future<List<MenuItem>> getByType(String type) async {
    final all = await getAll();
    final t = type.toLowerCase();
    return all.where((e) => e.type == t).toList();
  }

  Future<List<MenuItem>> getByCategory(String category) async {
    final all = await getAll();
    final c = category.toLowerCase();
    return all.where((e) => e.category == c).toList();
  }

  Future<List<MenuItem>> getSpecials() async {
    final specials = await getByCategory('spesial');
    if (specials.isNotEmpty) return specials;
    // Fallback: if no explicit 'spesial' category, treat all items as specials
    return getAll();
  }

  String _inferType(String name, String icon) {
    final lower = name.toLowerCase();
    if (icon.contains('emoji_food_beverage') || icon.contains('local_drink')) {
      return 'minuman';
    }
    if (lower.contains('teh') || lower.contains('jeruk') || lower.contains('kopi') || lower.contains('es ')) {
      return 'minuman';
    }
    return 'makanan';
  }

}
