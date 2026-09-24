import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/pill.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../products/controllers/categories_controller.dart';
import '../../settings/controllers/theme_controller.dart';
import '../../shell/controllers/nav_controller.dart';

//  <--------- Profile View --------->
//* TO show the signed-in user, appearance settings and library shortcuts
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const appVersion = '1.0.0';

  //  <--------- Sign Out Handler --------->
  //* TO confirm before clearing the session
  Future<void> _signOut() async {
    final ok = await confirmDialog(
      title: 'Sign out?',
      message:
          'You can sign back in any time. Favorites, bag and history stay on this device.',
      confirmLabel: 'Sign out',
    );
    if (ok) await Get.find<AuthController>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final auth = Get.find<AuthController>();
    final favorites = Get.find<FavoritesController>();
    final categories = Get.find<CategoriesController>();
    final theme = Get.find<ThemeController>();
    final nav = Get.find<NavController>();
    final bottomInset = AppBottomNav.contentInset(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //  <--------- Header Section --------->
          const AppTopBar(title: 'Profile', showAvatar: false),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
            sliver: SliverList.list(
              children: [
                //  <--------- Profile Card Section --------->
                //* TO show name, email and quick stats
                Obx(() {
                  final categoryCount =
                      categories.categories.value.valueOrNull?.length;
                  return _ProfileHeaderCard(
                    name: auth.displayName,
                    email: auth.email,
                    stats: [
                      ('${favorites.count}', 'Favorites', true),
                      (
                        categoryCount == null ? '—' : '$categoryCount',
                        'Categories',
                        false,
                      ),
                    ],
                  );
                }),
                //  <--------- Appearance Section --------->
                //* TO select theme mode like system, light and dark
                _Section(
                  label: 'Appearance',
                  children: [
                    Obx(
                      () => _SettingsRow(
                        icon: Icons.dark_mode_outlined,
                        title: 'Theme',
                        subtitle: switch (theme.mode.value) {
                          ThemeMode.system => 'Follows your device setting',
                          ThemeMode.light => 'Light mode',
                          ThemeMode.dark => 'Dark mode',
                        },
                        trailing: const SizedBox.shrink(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => SegmentedButton<ThemeMode>(
                            showSelectedIcon: false,
                            segments: [
                              ButtonSegment(
                                value: ThemeMode.system,
                                label: const Text('System'),
                                icon: Icon(
                                  Icons.brightness_auto_outlined,
                                  size: 16.r,
                                ),
                              ),
                              ButtonSegment(
                                value: ThemeMode.light,
                                label: const Text('Light'),
                                icon: Icon(
                                  Icons.light_mode_outlined,
                                  size: 16.r,
                                ),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                label: const Text('Dark'),
                                icon: Icon(
                                  Icons.dark_mode_outlined,
                                  size: 16.r,
                                ),
                              ),
                            ],
                            selected: {theme.mode.value},
                            onSelectionChanged: (set) =>
                                theme.setMode(set.first),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //  <--------- My Library Section --------->
                //* TO navigate to favorites and categories
                _Section(
                  label: 'My Library',
                  children: [
                    Obx(
                      () => _SettingsRow(
                        icon: Icons.favorite_border_rounded,
                        title: 'My Favorites',
                        subtitle: favorites.count == 0
                            ? 'Nothing saved yet'
                            : '${favorites.count} saved products',
                        badge: favorites.count == 0
                            ? null
                            : '${favorites.count} saved',
                        onTap: () => nav.select(NavController.favorites),
                      ),
                    ),
                    const _RowDivider(),
                    Obx(() {
                      final count =
                          categories.categories.value.valueOrNull?.length;
                      return _SettingsRow(
                        icon: Icons.grid_view_rounded,
                        title: 'Browse Categories',
                        subtitle: count == null
                            ? 'Explore the catalogue'
                            : '$count categories',
                        onTap: () => nav.select(NavController.explore),
                      );
                    }),
                  ],
                ),
                //!  <--------- Sign Out Section --------->
                //* TO sign out and show the app version
                SizedBox(height: 28.h),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: _signOut,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: c.brown,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                    icon: Icon(Icons.logout_rounded, size: 16.r),
                    label: const Text('Sign Out'),
                  ),
                ),
                SizedBox(height: 6.h),
                Center(
                  child: Text(
                    'Sell Store v$appVersion',
                    style: TextStyle(fontSize: 12.sp, color: c.brownMuted),
                  ),
                ),
                SizedBox(height: bottomInset),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  <--------- Profile Header Card Widget --------->
class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.name,
    required this.email,
    required this.stats,
  });

  final String name;
  final String email;
  final List<(String, String, bool)> stats;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(color: c.surface, boxShadow: softShadow),
        child: Stack(
          children: [
            Positioned(
              right: -48.w,
              top: -48.h,
              child: Container(
                width: 144.r,
                height: 144.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      c.chipRose.withValues(alpha: 0.5),
                      c.chipRose.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    UserAvatar(name: name, size: 64, showStatus: true),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.18,
                              color: c.ink,
                            ),
                          ),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.sp, color: c.brown),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: c.tintSoft,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      for (final (value, label, highlight) in stats)
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                value,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                  color: highlight ? c.accent : c.ink,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  color: c.brown,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//  <--------- Section Container Widget --------->
class _Section extends StatelessWidget {
  const _Section({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.14,
                color: c.brown,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: softShadow,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

//  <--------- Row Divider Widget --------->
class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Divider(height: 1, color: context.colors.divider),
    );
  }
}

//  <--------- Settings Row Widget --------->
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.badge,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final String? badge;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: c.tintStrong,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17.r, color: c.ink),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.14,
                      color: c.ink,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: c.brown),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              Pill(
                label: badge!,
                background: c.chipRose,
                foreground: c.onChipRose,
                leading: Dot(color: c.rose),
              ),
              SizedBox(width: 8.w),
            ],
            trailing ??
                Icon(Icons.chevron_right_rounded, size: 18.r, color: c.brown),
          ],
        ),
      ),
    );
  }
}
