import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../controllers/categories_controller.dart';
import '../controllers/product_list_controller.dart';

//  <--------- Category Chips Widget --------->
//* TO show a horizontal row of emoji chips for category filtering, hidden entirely if categories fail to load
class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key, required this.list});

  //  <--------- Fields --------->
  //* TO hold the product list these chips filter
  final ProductListController list;

  //  <--------- Emoji Map --------->
  //* TO map category slugs to an emoji
  static const _emoji = <String, String>{
    'beauty': '💄',
    'fragrances': '🌸',
    'furniture': '🛋️',
    'groceries': '🥑',
    'home-decoration': '🏠',
    'kitchen-accessories': '🍳',
    'laptops': '💻',
    'mens-shirts': '👔',
    'mens-shoes': '👟',
    'mens-watches': '⌚',
    'mobile-accessories': '🔌',
    'motorcycle': '🏍️',
    'skin-care': '✨',
    'smartphones': '📱',
    'sports-accessories': '🏀',
    'sunglasses': '🕶️',
    'tablets': '📟',
    'tops': '👕',
    'vehicle': '🚗',
    'womens-bags': '👜',
    'womens-dresses': '👗',
    'womens-jewellery': '💍',
    'womens-shoes': '👠',
    'womens-watches': '⌚',
  };

  //  <--------- Helpers --------->
  static String emojiFor(String slug) => _emoji[slug] ?? '🛍️';

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final categories = Get.find<CategoriesController>();

    return Obx(() {
      final selected = list.category.value;
      return categories.categories.value.when(
        loading: () => const SizedBox(height: 38),
        error: (_) => const SizedBox.shrink(),
        data: (slugs) {
          if (slugs.isEmpty) return const SizedBox.shrink();
          return SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: slugs.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _Chip(
                    label: 'All Items',
                    selected: selected == null,
                    leading: const Icon(Icons.check_rounded, size: 14),
                    onTap: () => list.setCategory(null),
                  );
                }
                final slug = slugs[index - 1];
                final isSelected = selected == slug;
                return _Chip(
                  label: '${emojiFor(slug)} ${Formatters.categoryLabel(slug)}',
                  selected: isSelected,
                  onTap: () => list.setCategory(isSelected ? null : slug),
                );
              },
            ),
          );
        },
      );
    });
  }
}

//  <--------- Chip Widget --------->
//* TO paint one selectable category chip
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.onButton : c.inkSoft;

    return Material(
      color: selected ? c.button : c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: selected ? c.button : c.border),
      ),
      shadowColor: Colors.black12,
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: selected ? 16 : 17,
            vertical: selected ? 10 : 11,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                IconTheme(
                  data: IconThemeData(color: fg),
                  child: leading!,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: fg,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
