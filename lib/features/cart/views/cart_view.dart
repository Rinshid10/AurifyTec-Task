import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/pill.dart';
import '../../../core/widgets/product_image.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../shell/controllers/nav_controller.dart';
import '../controllers/cart_controller.dart';
import '../data/cart_models.dart';

//  <--------- Cart View --------->
//* TO show the shopping bag with line items, an order summary and a checkout bar
//* TO compute totals only from catalogue product prices
class CartView extends GetView<CartController> {
  const CartView({super.key});

  //!  <--------- Clear All Handler --------->
  //* TO confirm before removing every item from the bag
  Future<void> _clearAll() async {
    final ok = await confirmDialog(
      title: 'Clear your bag?',
      message: 'This removes all ${controller.itemCount} items.',
      confirmLabel: 'Clear all',
    );
    if (ok) controller.clear();
  }

  //  <--------- Checkout Handler --------->
  //* TO explain that payments are out of scope for this demo
  Future<void> _checkout() {
    final count = controller.itemCount;
    return infoDialog(
      title: 'Checkout',
      message:
          'Payments are outside the scope of this demo. Your bag of '
          '$count item${count == 1 ? '' : 's'} '
          '(${Formatters.price(controller.total)}) stays saved on this device.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final auth = Get.find<AuthController>();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            CustomScrollView(
              slivers: [
                //  <--------- Header Section --------->
                //* TO show the back button, title and profile avatar
                SliverAppBar(
                  pinned: true,
                  toolbarHeight: 56.h,
                  titleSpacing: 0,
                  backgroundColor: c.background,
                  leading: IconButton(
                    tooltip: 'Back',
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18.r,
                      color: c.ink,
                    ),
                    onPressed: Get.back,
                  ),
                  title: const Text('Shopping Cart'),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: InkWell(
                        onTap: () => Get.find<NavController>().goToTab(
                          NavController.profile,
                        ),
                        customBorder: const CircleBorder(),
                        child: UserAvatar(name: auth.displayName, size: 32),
                      ),
                    ),
                  ],
                ),
                //!  <--------- Empty State Section --------->
                //* TO invite the user back to the catalogue when the bag is empty
                if (controller.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyView(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Your bag is empty',
                      subtitle:
                          'Add products from the catalogue to see them here.',
                      action: FilledButton.icon(
                        onPressed: Get.back,
                        icon: Icon(Icons.storefront_outlined, size: 18.r),
                        label: const Text('Continue shopping'),
                      ),
                    ),
                  )
                else
                  //  <--------- Bag Items Section --------->
                  //* TO list the bag header, one tile per line and the order summary
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      4.h,
                      16.w,
                      120.h + bottomInset,
                    ),
                    sliver: SliverList.list(
                      children: [
                        _BagHeader(
                          count: controller.itemCount,
                          onClear: _clearAll,
                        ),
                        SizedBox(height: 8.h),
                        for (final line in controller.lines) ...[
                          _CartLineTile(line: line),
                          SizedBox(height: 8.h),
                        ],
                        SizedBox(height: 16.h),
                        //  <--------- Order Summary Section --------->
                        _OrderSummary(
                          itemCount: controller.itemCount,
                          subtotal: controller.subtotal,
                          total: controller.total,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            //  <--------- Checkout Bar Section --------->
            //* TO pin the total and checkout button over the list
            if (!controller.isEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _CheckoutBar(
                  total: controller.total,
                  onCheckout: _checkout,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//  <--------- Bag Header Widget --------->
//* TO show the My Bag title with the item count and a clear all button
class _BagHeader extends StatelessWidget {
  const _BagHeader({required this.count, required this.onClear});

  //  <--------- Fields --------->
  final int count;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          //  <--------- Title Section --------->
          Text(
            'My Bag',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: c.ink,
            ),
          ),
          SizedBox(width: 6.w),
          //  <--------- Count Badge Section --------->
          Container(
            width: 24.r,
            height: 24.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.chipRose,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: c.accent,
              ),
            ),
          ),
          const Spacer(),
          //!  <--------- Clear All Section --------->
          Material(
            color: c.chipRose.withValues(alpha: 0.5),
            shape: const StadiumBorder(),
            child: InkWell(
              onTap: onClear,
              customBorder: const StadiumBorder(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.24,
                    color: c.accent,
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

//  <--------- Cart Line Tile Widget --------->
//* TO show one bag line with image, title, stock, price and a quantity stepper
class _CartLineTile extends GetView<CartController> {
  const _CartLineTile({required this.line});

  //  <--------- Fields --------->
  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final product = line.product;
    //* TO join brand and availability into one subtitle line
    final subtitle = [
      if (product.brand != null && product.brand!.isNotEmpty) product.brand!,
      product.availabilityStatus ??
          (product.inStock ? 'In stock' : 'Out of stock'),
    ].join(' · ');

    //!  <--------- Dismiss To Delete Section --------->
    //* TO remove the line when swiped from right to left
    return Dismissible(
      key: ValueKey('cart-${product.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.remove(product.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: c.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.delete_outline_rounded, color: c.danger),
      ),
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(12.r),
        clipBehavior: Clip.antiAlias,
        elevation: 0.5,
        shadowColor: Colors.black12,
        child: InkWell(
          //* TO open the product details when the tile is tapped
          onTap: () => Get.toNamed(
            AppRoutes.productDetailsPath(product.id),
            arguments: product,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Row(
              children: [
                //  <--------- Image Section --------->
                //* TO show the thumbnail with a category pill on top
                SizedBox(
                  width: 80.w,
                  height: 96.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: ColoredBox(
                          color: c.tint,
                          child: Padding(
                            padding: EdgeInsets.all(6.r),
                            child: ProductImage(
                              url: product.thumbnail,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 4.w,
                        bottom: 4.h,
                        child: Pill(
                          label: Formatters.categoryLabel(product.category),
                          background: c.ink.withValues(alpha: 0.7),
                          foreground: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                //  <--------- Details Section --------->
                Expanded(
                  child: SizedBox(
                    height: 96.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //!  <--------- Title And Remove Section --------->
                        //* TO show the product title with a small delete icon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: c.ink,
                                  height: 1.33,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.remove(product.id),
                              borderRadius: BorderRadius.circular(6.r),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(4.w, 2.h, 0, 6.h),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 16.r,
                                  color: c.brownMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        //  <--------- Stock Section --------->
                        //* TO show a stock dot with the brand and availability text
                        Row(
                          children: [
                            Dot(
                              color: product.inStock ? c.accent : c.danger,
                              size: 10,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: c.brown,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        //  <--------- Price And Quantity Section --------->
                        //* TO show the line total and disable plus at the max quantity
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                Formatters.price(line.lineTotal),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.18,
                                  color: c.ink,
                                ),
                              ),
                            ),
                            _QuantityStepper(
                              quantity: line.quantity,
                              onDecrement: () =>
                                  controller.decrement(product.id),
                              onIncrement:
                                  line.quantity <
                                      CartController.limitFor(product)
                                  ? () => controller.increment(product.id)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//  <--------- Quantity Stepper Widget --------->
//* TO show minus and plus buttons around the current quantity
class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  //  <--------- Fields --------->
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    //  <--------- Button Builder --------->
    //* TO render a round icon button that looks muted when disabled
    Widget button(IconData icon, VoidCallback? onTap) {
      return InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 24.r,
          height: 24.r,
          child: Icon(icon, size: 14.r, color: onTap == null ? c.muted : c.ink),
        ),
      );
    }

    //  <--------- Stepper Section --------->
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: c.tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove_rounded, onDecrement),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 20.w),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                  color: c.ink,
                ),
              ),
            ),
          ),
          button(Icons.add_rounded, onIncrement),
        ],
      ),
    );
  }
}

//  <--------- Order Summary Widget --------->
//* TO show item count, subtotal and the grand total in a card
class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.itemCount,
    required this.subtotal,
    required this.total,
  });

  //  <--------- Fields --------->
  final int itemCount;
  final double subtotal;
  final double total;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final labelStyle = TextStyle(fontSize: 14.sp, color: c.brown);
    final valueStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.14,
      color: c.ink,
    );

    //  <--------- Row Builder --------->
    //* TO lay out a label on the left and a value on the right
    Widget row(String label, String value, {TextStyle? style}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: style ?? valueStyle),
      ],
    );

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  <--------- Title Section --------->
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.18,
              color: c.ink,
            ),
          ),
          SizedBox(height: 8.h),
          //  <--------- Line Rows Section --------->
          row('Items', '$itemCount'),
          SizedBox(height: 8.h),
          row('Subtotal', Formatters.price(subtotal)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1, color: c.tintStrong),
          ),
          //  <--------- Total Section --------->
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: c.ink,
                ),
              ),
              Text(
                Formatters.price(total),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                  color: c.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//  <--------- Checkout Bar Widget --------->
//* TO show a blurred sticky bar with the total due and a checkout button
class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.total, required this.onCheckout});

  //  <--------- Fields --------->
  final double total;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: c.navBar,
            boxShadow: [
              BoxShadow(
                color: const Color(0x0F0F1B33),
                blurRadius: 24.r,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Row(
                children: [
                  //  <--------- Total Due Section --------->
                  //* TO show the label, formatted price and currency code
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL DUE',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: c.brown,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatters.price(total),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.48,
                              color: c.ink,
                              height: 1.33,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Text(
                              'USD',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: c.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  //  <--------- Checkout Button Section --------->
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 230.w),
                      child: SizedBox(
                        height: 48.h,
                        child: FilledButton(
                          onPressed: onCheckout,
                          style: FilledButton.styleFrom(
                            backgroundColor: c.ink,
                            foregroundColor: c.surface,
                            elevation: 3,
                            shadowColor: Colors.black26,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Proceed to Checkout',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(Icons.arrow_forward_rounded, size: 14.r),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
