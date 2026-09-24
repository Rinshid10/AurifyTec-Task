import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/badge_icon_button.dart';
import '../../products/data/product.dart';
import '../controllers/cart_controller.dart';

//  <--------- Cart Icon Button Widget --------->
//* TO show the bag icon with an item count badge that opens the cart screen
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key, this.filled = false, this.size = 44});

  //  <--------- Fields --------->
  final bool filled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    //  <--------- Badge Section --------->
    //* TO rebuild the badge whenever the item count changes
    return Obx(
      () => BadgeIconButton(
        icon: Icons.shopping_bag_outlined,
        count: cart.itemCount,
        tooltip: 'Shopping bag',
        filled: filled,
        size: size,
        onTap: () => Get.toNamed(AppRoutes.cart),
      ),
    );
  }
}

//  <--------- Add To Bag Helper --------->
//* TO share the add to bag behaviour and confirmation snackbar across screens
//* TO block out of stock products with a message
void addToBag(BuildContext context, Product product, {int quantity = 1}) {
  if (!product.inStock) {
    AppSnackBar.show(context, '"${product.title}" is out of stock.');
    return;
  }
  final total = Get.find<CartController>().add(product, quantity: quantity);
  AppSnackBar.show(
    context,
    total == quantity ? 'Added to your bag' : 'Bag updated · $total in bag',
    actionLabel: 'View bag',
    onAction: () => Get.toNamed(AppRoutes.cart),
  );
}
