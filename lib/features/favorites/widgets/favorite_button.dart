import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../products/data/product.dart';
import '../controllers/favorites_controller.dart';

//  <--------- Favorite Button Widget --------->
//* TO show a round translucent heart toggle that sits on top of product images
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.product, this.size = 32});

  //  <--------- Fields --------->
  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final favorites = Get.find<FavoritesController>();

    return Obx(() {
      final isFavorite = favorites.isFavorite(product.id);
      //  <--------- Heart Toggle Section --------->
      //* TO toggle the favorite and confirm with a short snackbar
      return Tooltip(
        message: isFavorite ? 'Remove from favorites' : 'Add to favorites',
        child: Material(
          color: c.surface.withValues(alpha: 0.9),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () {
              final added = favorites.toggle(product);
              AppSnackBar.show(
                context,
                added ? 'Added to favorites' : 'Removed from favorites',
                duration: const Duration(seconds: 1),
              );
            },
            customBorder: const CircleBorder(),
            //  <--------- Icon Section --------->
            //* TO scale between the filled and outlined heart on change
            child: SizedBox(
              width: size,
              height: size,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  key: ValueKey(isFavorite),
                  size: size / 2,
                  color: isFavorite ? c.rose : c.inkSoft,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
