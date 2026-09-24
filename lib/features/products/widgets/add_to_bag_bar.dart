import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/widgets/cart_button.dart';
import '../data/product.dart';

//  <--------- Add To Bag Bar Widget --------->
//* TO show the sticky conversion bar with quantity stepper, Add to Bag button and shipping and returns micro-copy
class AddToBagBar extends StatefulWidget {
  const AddToBagBar({super.key, required this.product});

  final Product product;

  @override
  State<AddToBagBar> createState() => _AddToBagBarState();
}

//  <--------- Add To Bag Bar State --------->
class _AddToBagBarState extends State<AddToBagBar> {
  //  <--------- Fields --------->
  int _quantity = 1;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final product = widget.product;
    final cart = Get.find<CartController>();

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: c.navBar,
            boxShadow: const [
              BoxShadow(
                color: Color(0x140F1B33),
                blurRadius: 24,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //  <--------- Stepper And Button Section --------->
                  Row(
                    children: [
                      _Stepper(
                        quantity: _quantity,
                        onDecrement: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        onIncrement:
                            _quantity < CartController.limitFor(product)
                            ? () => setState(() => _quantity++)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: product.inStock
                                ? () => addToBag(
                                    context,
                                    product,
                                    quantity: _quantity,
                                  )
                                : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: c.rose,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: c.muted,
                              disabledForegroundColor: Colors.white,
                              elevation: 6,
                              shadowColor: c.rose.withValues(alpha: 0.35),
                            ),
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 18,
                            ),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                product.inStock
                                    ? 'Add to Bag • ${Formatters.price(product.finalPrice * _quantity)}'
                                    : 'Out of stock',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  //  <--------- Micro-copy Section --------->
                  //* TO show bag count, shipping and returns notes when available
                  Obx(() {
                    final inBag = cart.quantityOf(product.id);
                    final notes = <(IconData, String, bool)>[
                      if (inBag > 0)
                        (
                          Icons.check_circle_rounded,
                          '$inBag in your bag',
                          true,
                        ),
                      if (product.shippingInformation != null)
                        (
                          Icons.local_shipping_outlined,
                          product.shippingInformation!,
                          false,
                        ),
                      if (product.returnPolicy != null)
                        (
                          Icons.assignment_return_outlined,
                          product.returnPolicy!,
                          false,
                        ),
                    ];
                    if (notes.isEmpty) return const SizedBox.shrink();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < notes.length; i++) ...[
                          if (i > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                '•',
                                style: TextStyle(fontSize: 10, color: c.brown),
                              ),
                            ),
                          Icon(
                            notes[i].$1,
                            size: 12,
                            color: notes[i].$3 ? c.accent : c.brown,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notes[i].$2,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              color: notes[i].$3 ? c.accent : c.brown,
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//  <--------- Stepper Widget --------->
//* TO show the pill quantity stepper from the sticky bar
class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget button(IconData icon, VoidCallback? onTap) {
      return Material(
        color: c.surface,
        shape: const CircleBorder(),
        elevation: 0.5,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 28,
            height: 28,
            child: Icon(icon, size: 14, color: onTap == null ? c.muted : c.ink),
          ),
        ),
      );
    }

    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: c.tintSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          button(Icons.remove_rounded, onDecrement),
          Text(
            '$quantity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.14,
              color: c.ink,
            ),
          ),
          button(Icons.add_rounded, onIncrement),
        ],
      ),
    );
  }
}
