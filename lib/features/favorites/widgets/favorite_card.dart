import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pill.dart';
import '../../../core/widgets/rating_badge.dart';
import '../../products/data/product.dart';
import '../../products/widgets/details/product_gallery.dart';
import '../../../core/widgets/product_image.dart';

//  <--------- Favorite Card Widget --------->
//* TO show a wishlist tile with image frame, status pill, remove heart, details and a move to bag button
class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onRemove,
    required this.onMoveToBag,
  });

  //  <--------- Fields --------->
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onMoveToBag;

  //* TO give the grid a fixed tile height
  static double get height => 323.h;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      elevation: 0.5,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  <--------- Image Section --------->
              //* TO show the hero thumbnail with a status pill and remove button on top
              SizedBox(
                height: 155.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: ColoredBox(
                        color: c.tintSoft,
                        child: Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Hero(
                            tag: ProductGallery.heroTag(product.id),
                            child: ProductImage(
                              url: product.thumbnail,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(top: 8.h, left: 8.w, child: _statusPill(c)),
                    //!  <--------- Remove Button Section --------->
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Tooltip(
                        message: 'Remove from favorites',
                        child: Material(
                          color: c.surface.withValues(alpha: 0.9),
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: onRemove,
                            customBorder: const CircleBorder(),
                            child: SizedBox(
                              width: 28.r,
                              height: 28.r,
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 14.r,
                                color: c.rose,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              //  <--------- Brand Section --------->
              //* TO fall back to the category label when the product has no brand
              Text(
                (product.brand ?? Formatters.categoryLabel(product.category))
                    .toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: c.brown,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 2.h),
              //  <--------- Title Section --------->
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.18,
                  color: c.ink,
                  height: 1.33,
                ),
              ),
              SizedBox(height: 4.h),
              //  <--------- Rating Section --------->
              RatingBadge(
                rating: product.rating,
                reviewCount: product.reviewCount,
                ratingSize: 12,
                countSize: 12,
                ratingColor: c.ink,
                countColor: c.brown,
              ),
              SizedBox(height: 8.h),
              //  <--------- Price Section --------->
              //* TO show the final price next to the struck original price or the stock text
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      Formatters.price(product.finalPrice),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.18,
                        color: c.ink,
                        height: 1.33,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      product.hasDiscount
                          ? Formatters.price(product.price)
                          : (product.inStock ? 'In Stock' : 'Sold out'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: c.brown,
                        decoration: product.hasDiscount
                            ? TextDecoration.lineThrough
                            : null,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              //  <--------- Move To Bag Section --------->
              //* TO show a full width rose button that is greyed out when sold out
              Material(
                color: product.inStock ? c.rose : c.muted,
                shape: const StadiumBorder(),
                child: InkWell(
                  onTap: product.inStock ? onMoveToBag : null,
                  customBorder: const StadiumBorder(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 14.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          product.inStock ? 'Move to Bag' : 'Sold out',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.24,
                            color: Colors.white,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  <--------- Status Pill --------->
  //* TO pick sold out, low stock or discount and nothing when none apply
  Widget _statusPill(AppColors c) {
    if (!product.inStock) {
      return Pill(label: 'Sold out', background: c.ink, foreground: c.surface);
    }
    if (product.lowStock) {
      return Pill(
        label: 'Low Stock',
        background: c.gold,
        foreground: c.onGold,
        leading: Dot(color: c.goldDeep),
      );
    }
    if (product.hasDiscount) {
      return Pill(
        label: Formatters.discount(product.discountPercentage),
        background: c.rose,
        foreground: Colors.white,
      );
    }
    return const SizedBox.shrink();
  }
}
