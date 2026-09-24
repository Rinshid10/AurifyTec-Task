import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pill.dart';
import '../../../core/widgets/price_text.dart';
import '../../../core/widgets/product_image.dart';
import '../../../core/widgets/rating_badge.dart';
import '../../cart/widgets/cart_button.dart';
import '../../favorites/widgets/favorite_button.dart';
import '../data/product.dart';
import 'details/product_gallery.dart';

//  <--------- Product Card Widget --------->
//* TO show a product tile with framed image, discount pill, favorite toggle, category, title, rating and a price row with add-to-bag
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.enableHero = true,
  });

  //  <--------- Fields --------->
  final Product product;
  final VoidCallback onTap;

  //  <--------- Hero Flag --------->
  //* TO disable the hero when another card in the same route already shows this product so two heroes do not share the tag
  final bool enableHero;

  //  <--------- Constants --------->
  //* TO fix the card height since the image frame is a fixed 144px in the design
  static const height = 272.0;

  //  <--------- Helpers --------->
  //* TO wrap the thumbnail in a Hero when enabled
  Widget _image(Product product) {
    final image = ProductImage(url: product.thumbnail, fit: BoxFit.contain);
    if (!enableHero) return image;
    return Hero(tag: ProductGallery.heroTag(product.id), child: image);
  }

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  <--------- Image Section --------->
              SizedBox(
                height: 144,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ColoredBox(
                        color: c.imageBg,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _image(product),
                        ),
                      ),
                    ),
                    if (product.hasDiscount)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Pill(
                          label: Formatters.discount(
                            product.discountPercentage,
                          ),
                          background: c.rose,
                          foreground: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: FavoriteButton(product: product),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //  <--------- Category And Title Section --------->
              Text(
                Formatters.categoryLabel(product.category).toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: c.muted,
                  height: 1.5,
                ),
              ),
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: c.inkSoft,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              //  <--------- Rating Section --------->
              RatingBadge(
                rating: product.rating,
                reviewCount: product.reviewCount,
              ),
              const Spacer(),
              //  <--------- Price Row Section --------->
              Row(
                children: [
                  Expanded(child: PriceText.forProduct(product)),
                  const SizedBox(width: 6),
                  _AddToBagButton(product: product),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  <--------- Add To Bag Button Widget --------->
//* TO show the small square add-to-bag button from the design
class _AddToBagButton extends StatelessWidget {
  const _AddToBagButton({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: 'Add to bag',
      child: Material(
        color: c.button,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => addToBag(context, product),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 28,
            height: 28,
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 14,
              color: c.onButton,
            ),
          ),
        ),
      ),
    );
  }
}
