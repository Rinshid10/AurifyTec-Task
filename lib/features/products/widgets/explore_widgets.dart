import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pill.dart';
import '../../../core/widgets/price_text.dart';
import '../../../core/widgets/product_image.dart';
import '../../../core/widgets/rating_badge.dart';
import '../../cart/widgets/cart_button.dart';
import '../../favorites/widgets/favorite_button.dart';
import '../controllers/categories_controller.dart';
import '../data/product.dart';
import 'category_chips.dart';

//  <--------- Explore Search Bar Widget --------->
//* TO show the white pill search field from the Explore design
class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  //  <--------- Fields --------->
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: softShadow,
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 18, color: c.brown),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: TextStyle(fontSize: 16, color: c.ink),
              decoration: InputDecoration(
                hintText: 'Search products, brands, tags...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: c.brown.withValues(alpha: 0.6),
                ),
                filled: false,
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          //  <--------- Clear Button Section --------->
          //* TO show the clear button only when text is present
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox(width: 4);
              return Material(
                color: c.tint,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onClear,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.close_rounded, size: 16, color: c.ink),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//  <--------- Trending Row Widget --------->
//* TO show the Popular label followed by tappable suggestion pills built from the most common tags
class TrendingRow extends StatelessWidget {
  const TrendingRow({super.key, required this.terms, required this.onTap});

  //  <--------- Fields --------->
  final List<String> terms;
  final ValueChanged<String> onTap;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (terms.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 14,
                  color: c.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  'POPULAR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: c.accent,
                  ),
                ),
              ],
            ),
          ),
          for (final term in terms)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Center(
                child: Material(
                  color: c.surface,
                  shape: const StadiumBorder(),
                  elevation: 0.5,
                  shadowColor: Colors.black12,
                  child: InkWell(
                    onTap: () => onTap(term),
                    customBorder: const StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      child: Text(
                        Formatters.categoryLabel(term),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.24,
                          color: c.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//  <--------- Category Grid Card Widget --------->
//* TO show a category tile with emoji circle, name, live item count and a product thumbnail in the corner
class CategoryGridCard extends StatelessWidget {
  const CategoryGridCard({super.key, required this.slug, required this.onTap});

  //  <--------- Fields --------->
  final String slug;
  final VoidCallback onTap;

  //  <--------- Constants --------->
  static const height = 112.0;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final categories = Get.find<CategoriesController>();

    return SizedBox(
      height: height,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        elevation: 0.5,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          child: Obx(() {
            final summary = categories.summaryOf(slug);
            final thumbnail = summary.valueOrNull?.thumbnail;
            final count = summary.when(
              data: (s) => '${s.total} items',
              loading: () => '…',
              error: (_) => 'Browse',
            );
            return Stack(
              children: [
                if (thumbnail != null)
                  Positioned(
                    right: -12,
                    bottom: -12,
                    width: 96,
                    height: 96,
                    child: Opacity(
                      opacity: 0.9,
                      child: ProductImage(url: thumbnail, fit: BoxFit.contain),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: c.tintStrong,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          CategoryChips.emojiFor(slug),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Formatters.categoryLabel(slug),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.18,
                            color: c.ink,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        count,
                        style: TextStyle(
                          fontSize: 12,
                          color: c.brown,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

//  <--------- Brand Bubble Widget --------->
//* TO show a round initials tile for a brand that searches the catalogue when tapped
class BrandBubble extends StatelessWidget {
  const BrandBubble({
    super.key,
    required this.name,
    required this.onTap,
    this.accent = false,
  });

  //  <--------- Fields --------->
  final String name;
  final VoidCallback onTap;
  final bool accent;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.surface,
                shape: BoxShape.circle,
                boxShadow: softShadow,
              ),
              child: Text(
                Formatters.initials(name),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: accent ? c.accent : c.ink,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.24,
                height: 1.2,
                color: c.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  <--------- Top Rated Card Widget --------->
//* TO show a square-image product card with brand, title, rating and a round accent add-to-bag button
class TopRatedCard extends StatelessWidget {
  const TopRatedCard({
    super.key,
    required this.product,
    required this.onTap,
    this.badge,
  });

  //  <--------- Fields --------->
  final Product product;
  final VoidCallback onTap;

  //  <--------- Badge --------->
  //* TO override the discount pill with a label like Top rated
  final String? badge;

  //  <--------- Constants --------->
  //* TO fix the height of the text block under the square image
  static const textBlockHeight = 144.0;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final label =
        badge ??
        (product.hasDiscount
            ? '${product.discountPercentage.toStringAsFixed(0)}% Off'
            : null);

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 0.5,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  <--------- Image Section --------->
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ColoredBox(
                        color: c.tintSoft,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ProductImage(
                            url: product.thumbnail,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    if (label != null)
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Pill(
                          label: label,
                          background: c.surface.withValues(alpha: 0.9),
                          foreground: badge == null ? c.accent : c.ink,
                        ),
                      ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: FavoriteButton(product: product, size: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //  <--------- Brand And Title Section --------->
              Text(
                (product.brand ?? Formatters.categoryLabel(product.category))
                    .toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: c.brownMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.14,
                  color: c.ink,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              //  <--------- Rating Section --------->
              RatingBadge(
                rating: product.rating,
                reviewCount: product.reviewCount,
                ratingSize: 12,
                countSize: 12,
                ratingColor: c.ink,
                countColor: c.brownMuted,
              ),
              const Spacer(),
              //  <--------- Price And Add To Bag Section --------->
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PriceText(
                          price: product.finalPrice,
                          priceSize: 18,
                          priceColor: c.ink,
                        ),
                        if (product.hasDiscount)
                          Text(
                            Formatters.price(product.price),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              decoration: TextDecoration.lineThrough,
                              color: c.brownMuted,
                            ),
                          )
                        else
                          Text(
                            product.inStock ? 'In stock' : 'Out of stock',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              color: c.accent,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Material(
                    color: c.rose,
                    shape: const CircleBorder(),
                    elevation: 2,
                    shadowColor: Colors.black26,
                    child: InkWell(
                      onTap: () => addToBag(context, product),
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
