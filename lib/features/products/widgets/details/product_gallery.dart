import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pill.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../favorites/widgets/favorite_button.dart';
import '../../data/product.dart';

//  <--------- Product Gallery Widget --------->
//* TO show a swipeable image gallery with discount and availability badges, a favorite toggle and page dots, falling back to the thumbnail when there are no gallery images
class ProductGallery extends StatefulWidget {
  const ProductGallery({super.key, required this.product});

  //  <--------- Fields --------->
  final Product product;

  //  <--------- Hero Tag --------->
  //* TO share the tag with the list cards so the first image animates across
  static String heroTag(int productId) => 'product-image-$productId';

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

//  <--------- Product Gallery State --------->
class _ProductGalleryState extends State<ProductGallery> {
  //  <--------- Fields --------->
  int _index = 0;

  //  <--------- Images --------->
  //* TO fall back to the thumbnail when the product has no gallery images
  List<String> get _images => widget.product.images.isNotEmpty
      ? widget.product.images
      : [widget.product.thumbnail];

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final product = widget.product;
    final images = _images;
    final availability =
        product.availabilityStatus ??
        (product.inStock ? 'In Stock' : 'Out of Stock');

    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: softShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            //  <--------- Image Pager Section --------->
            //* TO wrap only the first image in a Hero
            PageView.builder(
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final image = Padding(
                  padding: EdgeInsets.all(28.r),
                  child: ProductImage(url: images[i], fit: BoxFit.contain),
                );
                return i == 0
                    ? Hero(
                        tag: ProductGallery.heroTag(product.id),
                        child: image,
                      )
                    : image;
              },
            ),
            //  <--------- Badges Section --------->
            Positioned(
              top: 16.h,
              left: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.hasDiscount) ...[
                    Pill(
                      label:
                          '${Formatters.discount(product.discountPercentage)} OFF',
                      background: c.rose,
                      foreground: Colors.white,
                      fontSize: 12,
                      letterSpacing: -0.3,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  Pill(
                    label: availability,
                    background: c.surface.withValues(alpha: 0.9),
                    foreground: c.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.24,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    leading: Icon(
                      product.inStock
                          ? Icons.check_circle_outline_rounded
                          : Icons.remove_circle_outline_rounded,
                      size: 12.r,
                      color: product.inStock ? c.success : c.danger,
                    ),
                  ),
                ],
              ),
            ),
            //  <--------- Favorite Section --------->
            Positioned(
              top: 16.h,
              right: 16.w,
              child: FavoriteButton(product: product, size: 40),
            ),
            //  <--------- Page Dots Section --------->
            if (images.length > 1)
              Positioned(
                bottom: 16.h,
                left: 0,
                right: 0,
                child: _PageDots(count: images.length, current: _index),
              ),
          ],
        ),
      ),
    );
  }
}

//  <--------- Page Dots Widget --------->
//* TO paint the pager indicator with the current dot stretched
class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: i == current ? 24.w : 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: i == current ? c.accent : c.ink.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}
