import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/cart/widgets/cart_button.dart';
import '../../features/favorites/controllers/favorites_controller.dart';
import '../../features/shell/controllers/nav_controller.dart';
import 'badge_icon_button.dart';
import 'user_avatar.dart';

//  <--------- App Top Bar Widget --------->
//* TO render the pinned tab header with the page title on the left and favorites, bag and avatar shortcuts on the right
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.showFavorites = true,
    this.showAvatar = true,
  });

  //  <--------- Fields --------->
  final String title;
  final bool showFavorites;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final favorites = Get.find<FavoritesController>();
    final auth = Get.find<AuthController>();
    final nav = Get.find<NavController>();

    return SliverAppBar(
      pinned: true,
      toolbarHeight: 56,
      titleSpacing: 16,
      backgroundColor: c.background,
      title: Text(title),
      actions: [
        //  <--------- Favorites Shortcut --------->
        //* TO jump to the favorites tab and show the saved count as a badge
        if (showFavorites)
          Obx(
            () => BadgeIconButton(
              icon: Icons.favorite_border_rounded,
              count: favorites.count,
              tooltip: 'Favorites',
              onTap: () => nav.select(NavController.favorites),
            ),
          ),
        //  <--------- Bag Shortcut --------->
        const CartIconButton(),
        //  <--------- Avatar --------->
        //* TO open the profile tab from the avatar, or keep spacing when it is hidden
        if (showAvatar)
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: Obx(
              () => InkWell(
                onTap: () => nav.select(NavController.profile),
                customBorder: const CircleBorder(),
                child: UserAvatar(name: auth.displayName, size: 32),
              ),
            ),
          )
        else
          const SizedBox(width: 12),
      ],
    );
  }
}
