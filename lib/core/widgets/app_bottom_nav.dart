import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme.dart';
import '../../features/favorites/controllers/favorites_controller.dart';

//  <--------- App Bottom Nav Widget --------->
//* TO render the translucent four-tab bar where the active tab gets a pill and bold label and Favorites shows a dot when anything is saved
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  //  <--------- Fields --------->
  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const favoritesTab = 2;

  //  <--------- Layout Metrics --------->
  //* TO expose the bar height so scrolling tab content can pad past it
  static const height = 84.0;

  //* TO compute the bottom padding a tab needs so its last item clears the bar
  static double contentInset(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom + height;

  //  <--------- Tab Items --------->
  static const _items = [
    (Icons.grid_view_rounded, 'Products'),
    (Icons.explore_outlined, 'Explore'),
    (Icons.favorite_border_rounded, 'Favorites'),
    (Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final favorites = Get.find<FavoritesController>();

    return ClipRect(
      //  <--------- Blurred Container --------->
      //* TO blur whatever scrolls under the bar and draw the top border and shadow
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: c.navBar,
            border: Border(top: BorderSide(color: c.border)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 24,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 9, 24, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //  <--------- Tab Row --------->
                  //* TO build each tab, wrapping only the Favorites tab in Obx so it alone reacts to the favorites list
                  for (var i = 0; i < _items.length; i++)
                    if (i == favoritesTab)
                      Obx(
                        () => _NavItem(
                          icon: _items[i].$1,
                          label: _items[i].$2,
                          active: i == currentIndex,
                          showDot: favorites.items.isNotEmpty,
                          onTap: () => onSelected(i),
                        ),
                      )
                    else
                      _NavItem(
                        icon: _items[i].$1,
                        label: _items[i].$2,
                        active: i == currentIndex,
                        showDot: false,
                        onTap: () => onSelected(i),
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

//  <--------- Nav Item Widget --------->
//* TO draw one tab with its animated pill, optional dot and label
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.showDot,
    required this.onTap,
  });

  //  <--------- Fields --------->
  final IconData icon;
  final String label;
  final bool active;
  final bool showDot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  <--------- Icon Pill --------->
            //* TO widen and tint the pill behind the icon when the tab is active
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: active ? 20 : 6,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: active ? c.border : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 20, color: active ? c.ink : c.muted),
                  //  <--------- Saved Dot --------->
                  if (showDot)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.roseSoft,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            //  <--------- Label --------->
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? c.ink : c.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
