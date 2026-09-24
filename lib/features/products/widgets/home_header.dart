import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/badge_icon_button.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../cart/widgets/cart_button.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../shell/controllers/nav_controller.dart';

//  <--------- Home Header Widget --------->
//* TO show the greeting bar with avatar, favorites and bag shortcuts, then the search field and filter button
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onFilterTap,
    required this.filterActive,
  });

  //  <--------- Fields --------->
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final VoidCallback onFilterTap;
  final bool filterActive;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final auth = Get.find<AuthController>();
    final favorites = Get.find<FavoritesController>();

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  <--------- Greeting Row Section --------->
          Row(
            children: [
              Obx(
                () => UserAvatar(
                  name: auth.displayName,
                  size: 44,
                  showStatus: true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME BACK',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: c.muted,
                        height: 1.3,
                      ),
                    ),
                    Obx(
                      () => Text(
                        'Hello, ${auth.firstName} ✨',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.45,
                          color: c.ink,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => BadgeIconButton(
                  icon: Icons.favorite_border_rounded,
                  tooltip: 'Favorites',
                  count: favorites.count,
                  filled: true,
                  size: 40,
                  onTap: () =>
                      Get.find<NavController>().select(NavController.favorites),
                ),
              ),
              SizedBox(width: 10.w),
              CartIconButton(filled: true, size: 40),
            ],
          ),
          SizedBox(height: 16.h),
          //  <--------- Search Row Section --------->
          Row(
            children: [
              Expanded(
                child: HomeSearchField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  onClear: onSearchCleared,
                ),
              ),
              SizedBox(width: 10.w),
              _FilterButton(active: filterActive, onTap: onFilterTap),
            ],
          ),
        ],
      ),
    );
  }
}

//  <--------- Filter Button Widget --------->
//* TO open the sort and filter sheet with a dot when a filter is active
class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: 'Sort & filter',
      child: Material(
        color: c.button,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            width: 44.r,
            height: 44.r,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.tune_rounded,
                    size: 20.r,
                    color: c.onButton,
                  ),
                ),
                if (active)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: c.surface,
                        shape: BoxShape.circle,
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

//  <--------- Home Search Field Widget --------->
//* TO show the grey rounded search input with a clear button when text is present
class HomeSearchField extends StatelessWidget {
  const HomeSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: c.ink,
          ),
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: Icon(Icons.search_rounded, size: 20.r, color: c.muted),
            prefixIconConstraints: BoxConstraints(minWidth: 44.w),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    icon: Icon(Icons.close_rounded, size: 18.r, color: c.muted),
                    tooltip: 'Clear',
                    onPressed: onClear,
                  ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 13.h,
            ),
          ),
        );
      },
    );
  }
}
