import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/badge_icon_button.dart';
import '../../cart/widgets/cart_button.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../shell/controllers/nav_controller.dart';
import '../bindings/product_details_binding.dart';
import '../controllers/product_details_controller.dart';
import '../widgets/add_to_bag_bar.dart';
import '../widgets/details/product_gallery.dart';
import '../widgets/details/product_summary.dart';
import '../widgets/details/spec_accordion.dart';

//  <--------- Product Details View --------->
//* TO show gallery, brand and rating, title, description, price bar, quick facts, tags and specifications with the add-to-bag bar pinned at the bottom
class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  //  <--------- Controller --------->
  //* TO resolve the controller once, because Get.parameters is global and is overwritten when another route opens on top
  late final ProductDetailsController controller;

  @override
  void initState() {
    super.initState();
    final id = int.tryParse(Get.parameters['id'] ?? '') ?? -1;
    controller = Get.find<ProductDetailsController>(
      tag: ProductDetailsBinding.tagFor(id),
    );
  }

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Obx(() {
      final state = controller.state.value;
      final product = controller.product;

      //!  <--------- Loading And Error States --------->
      //* TO show a plain scaffold with a spinner or retry when nothing is cached yet
      if (product == null) {
        return Scaffold(
          appBar: AppBar(leading: const BackButton()),
          body: state.when(
            loading: () => const AppLoadingView(),
            error: (error) => AppErrorView(
              message: ApiException.messageFor(error),
              onRetry: controller.load,
            ),
            data: (_) => const SizedBox.shrink(),
          ),
        );
      }

      return Scaffold(
        body: Stack(
          children: [
            //  <--------- Scrollable Content Section --------->
            RefreshIndicator(
              onRefresh: controller.load,
              child: CustomScrollView(
                slivers: [
                  //  <--------- App Bar Section --------->
                  const _DetailsAppBar(),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      4.h,
                      16.w,
                      128.h + bottomInset,
                    ),
                    sliver: SliverList.list(
                      children: [
                        //  <--------- Gallery Section --------->
                        ProductGallery(product: product),
                        SizedBox(height: 16.h),
                        //!  <--------- Stale Banner Section --------->
                        //* TO warn that a refresh failed and cached details are shown
                        if (state.hasError)
                          _StaleBanner(
                            message: ApiException.messageFor(
                              state.errorOrNull!,
                            ),
                            onRetry: controller.load,
                          ),
                        //  <--------- Brand And Rating Section --------->
                        BrandRatingRow(product: product),
                        SizedBox(height: 16.h),
                        //  <--------- Title And Description Section --------->
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.48,
                            color: c.ink,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: c.brown,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        //  <--------- Price Section --------->
                        PriceBar(product: product),
                        SizedBox(height: 16.h),
                        //  <--------- Quick Facts Section --------->
                        QuickFacts(product: product),
                        //  <--------- Tags Section --------->
                        if (product.tags.isNotEmpty) ...[
                          SizedBox(height: 20.h),
                          TagRow(tags: product.tags),
                        ],
                        SizedBox(height: 20.h),
                        //  <--------- Specifications Section --------->
                        Accordion(
                          icon: Icons.straighten_rounded,
                          title: 'Specifications',
                          initiallyExpanded: true,
                          child: SpecTable(product: product),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //  <--------- Add To Bag Bar Section --------->
            //* TO pin the conversion bar at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AddToBagBar(product: product),
            ),
          ],
        ),
      );
    });
  }
}

//* TO show the back button, title, cart and favorites shortcuts
class _DetailsAppBar extends StatelessWidget {
  const _DetailsAppBar();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final favorites = Get.find<FavoritesController>();
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 56.h,
      titleSpacing: 0,
      backgroundColor: c.background,
      leading: IconButton(
        tooltip: 'Back',
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.r, color: c.ink),
        onPressed: Get.back,
      ),
      title: const Text('Product Details'),
      actions: [
        const CartIconButton(),
        Obx(
          () => BadgeIconButton(
            icon: Icons.favorite_border_rounded,
            count: favorites.count,
            tooltip: 'Favorites',
            onTap: () =>
                Get.find<NavController>().goToTab(NavController.favorites),
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}

//!  <--------- Stale Banner Widget --------->
//* TO show above cached details when a refresh failed, with a retry
class _StaleBanner extends StatelessWidget {
  const _StaleBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: MaterialBanner(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
        backgroundColor: c.danger.withValues(alpha: 0.08),
        content: Text(
          'Showing cached details. $message',
          style: TextStyle(color: c.danger, fontSize: 12.sp),
        ),
        actions: [TextButton(onPressed: onRetry, child: const Text('Retry'))],
      ),
    );
  }
}
