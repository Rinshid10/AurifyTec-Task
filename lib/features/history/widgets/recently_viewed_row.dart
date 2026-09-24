import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/product_image.dart';
import '../../../core/widgets/section_header.dart';
import '../../favorites/widgets/favorite_button.dart';
import '../controllers/recently_viewed_controller.dart';

//  <--------- Recently Viewed Row Widget --------->
//* TO show a Recently Viewed header with a horizontal strip of compact cards
//* TO render nothing when the history is empty
class RecentlyViewedRow extends StatelessWidget {
  const RecentlyViewedRow({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final history = Get.find<RecentlyViewedController>();

    return Obx(() {
      //!  <--------- Empty State Section --------->
      final items = history.items;
      if (items.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //!  <--------- Header Section --------->
          //* TO show the history icon and title with a clear action
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: Row(
              children: [
                Icon(Icons.history_rounded, size: 16.r, color: c.accent),
                SizedBox(width: 8.w),
                Expanded(
                  child: SectionHeader(
                    title: 'Recently Viewed',
                    titleSize: 18,
                    actionLabel: 'Clear',
                    actionColor: c.accent,
                    onAction: history.clear,
                    padding: EdgeInsets.only(bottom: 8.h),
                  ),
                ),
              ],
            ),
          ),
          //  <--------- Cards Strip Section --------->
          //* TO scroll compact product cards horizontally
          SizedBox(
            height: 200.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              itemCount: items.length,
              separatorBuilder: (_, _) => SizedBox(width: 16.w),
              itemBuilder: (context, i) {
                final product = items[i];
                //  <--------- Compact Card Section --------->
                //* TO open the product details when the card is tapped
                return SizedBox(
                  width: 144.w,
                  child: Material(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    clipBehavior: Clip.antiAlias,
                    elevation: 0.5,
                    shadowColor: Colors.black12,
                    child: InkWell(
                      onTap: () => Get.toNamed(
                        AppRoutes.productDetailsPath(product.id),
                        arguments: product,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //  <--------- Image Section --------->
                            //* TO show the thumbnail with a favorite toggle on top
                            SizedBox(
                              height: 124.h,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: ColoredBox(
                                      color: c.tintSoft,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.r),
                                        child: ProductImage(
                                          url: product.thumbnail,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6.h,
                                    right: 6.w,
                                    child: FavoriteButton(
                                      product: product,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            //  <--------- Title And Price Section --------->
                            Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                                color: c.brown,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              Formatters.price(product.finalPrice),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.24,
                                color: c.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
