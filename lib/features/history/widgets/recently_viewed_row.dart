import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Row(
              children: [
                Icon(Icons.history_rounded, size: 16, color: c.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: SectionHeader(
                    title: 'Recently Viewed',
                    titleSize: 18,
                    actionLabel: 'Clear',
                    actionColor: c.accent,
                    onAction: history.clear,
                    padding: const EdgeInsets.only(bottom: 8),
                  ),
                ),
              ],
            ),
          ),
          //  <--------- Cards Strip Section --------->
          //* TO scroll compact product cards horizontally
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final product = items[i];
                //  <--------- Compact Card Section --------->
                //* TO open the product details when the card is tapped
                return SizedBox(
                  width: 144,
                  child: Material(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    elevation: 0.5,
                    shadowColor: Colors.black12,
                    child: InkWell(
                      onTap: () => Get.toNamed(
                        AppRoutes.productDetailsPath(product.id),
                        arguments: product,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //  <--------- Image Section --------->
                            //* TO show the thumbnail with a favorite toggle on top
                            SizedBox(
                              height: 124,
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
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: FavoriteButton(
                                      product: product,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            //  <--------- Title And Price Section --------->
                            Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                                color: c.brown,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              Formatters.price(product.finalPrice),
                              style: TextStyle(
                                fontSize: 12,
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
