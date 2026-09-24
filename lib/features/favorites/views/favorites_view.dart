import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/pill.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../history/widgets/recently_viewed_row.dart';
import '../../products/data/product.dart';
import '../../shell/controllers/nav_controller.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/favorite_card.dart';

//  <--------- Favorites Sort Enum --------->
//* TO list the sort orders offered in the sort menu with their labels
enum _FavoritesSort {
  recent('Recently added'),
  priceLowHigh('Price: low to high'),
  priceHighLow('Price: high to low'),
  topRated('Top rated');

  const _FavoritesSort(this.label);

  final String label;
}

//  <--------- Favorites View --------->
//* TO show the wishlist tab with count, sort menu, category chips, cards and a move to bag bar
class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

//  <--------- Favorites View State --------->
class _FavoritesViewState extends State<FavoritesView> {
  //  <--------- Fields --------->
  //* TO mark the low stock chip with a key that cannot clash with a category
  static const _lowStockKey = '__low_stock';

  String? _filter;
  _FavoritesSort _sort = _FavoritesSort.recent;

  FavoritesController get _favorites => Get.find<FavoritesController>();
  CartController get _cart => Get.find<CartController>();

  //!  <--------- Remove Handler --------->
  //* TO remove a favorite and offer an undo in the snackbar
  void _remove(Product product) {
    _favorites.remove(product.id);
    AppSnackBar.show(
      context,
      'Removed "${product.title}"',
      actionLabel: 'Undo',
      onAction: () => _favorites.add(product),
    );
  }

  //  <--------- Move To Bag Handler --------->
  //* TO add one product to the bag and drop it from favorites
  void _moveToBag(Product product) {
    _cart.add(product);
    _favorites.remove(product.id);
    AppSnackBar.show(
      context,
      'Moved "${product.title}" to your bag',
      actionLabel: 'View bag',
      onAction: () => Get.toNamed(AppRoutes.cart),
    );
  }

  //  <--------- Move All To Bag Handler --------->
  //* TO move every in stock favorite to the bag in one go
  void _moveAllToBag(List<Product> products) {
    final inStock = products.where((p) => p.inStock).toList();
    if (inStock.isEmpty) return;
    for (final p in inStock) {
      _cart.add(p);
      _favorites.remove(p.id);
    }
    AppSnackBar.show(
      context,
      'Moved ${inStock.length} items to your bag',
      actionLabel: 'View bag',
      onAction: () => Get.toNamed(AppRoutes.cart),
    );
  }

  //  <--------- Filter And Sort --------->
  //* TO apply the selected chip filter and then the selected sort order
  List<Product> _apply(List<Product> all) {
    var list = all;
    if (_filter == _lowStockKey) {
      list = list.where((p) => p.lowStock).toList();
    } else if (_filter != null) {
      list = list.where((p) => p.category == _filter).toList();
    }
    list = [...list];
    switch (_sort) {
      case _FavoritesSort.recent:
        list = list.reversed.toList();
      case _FavoritesSort.priceLowHigh:
        list.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
      case _FavoritesSort.priceHighLow:
        list.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
      case _FavoritesSort.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottomInset = AppBottomNav.contentInset(context);

    return Scaffold(
      body: Obx(() {
        //  <--------- Derived Data --------->
        //* TO count favorites per category, find low stock and total the in stock prices
        //* TO reset the filter when its category no longer has any favorites
        final all = _favorites.products;
        final visible = _apply(all);

        final counts = <String, int>{};
        for (final p in all) {
          counts[p.category] = (counts[p.category] ?? 0) + 1;
        }
        final categoryChips = counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final lowStock = all.where((p) => p.lowStock).length;
        if (_filter != null &&
            _filter != _lowStockKey &&
            !counts.containsKey(_filter)) {
          _filter = null;
        }
        final inStock = all.where((p) => p.inStock).toList();
        final inStockTotal = inStock.fold<double>(
          0,
          (sum, p) => sum + p.finalPrice,
        );

        return CustomScrollView(
          slivers: [
            //  <--------- Header Section --------->
            const AppTopBar(title: 'Wishlist Favorites', showFavorites: false),
            //  <--------- Title Section --------->
            //* TO show the My Favorites title, saved count pill and sort menu
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'My Favorites',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                            color: c.ink,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Pill(
                          label: '${all.length} saved',
                          background: c.chipRose,
                          foreground: c.onChipRose,
                        ),
                        const Spacer(),
                        _SortMenu(
                          current: _sort,
                          onSelected: (s) => setState(() => _sort = s),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      all.isEmpty
                          ? 'Tap the heart on any product to keep it here.'
                          : 'Products you saved, kept on this device.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: c.brown,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //  <--------- Filter Chips Section --------->
            //* TO filter by all, the top six categories or low stock
            if (all.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: [
                      _CountChip(
                        label: 'All',
                        count: all.length,
                        selected: _filter == null,
                        onTap: () => setState(() => _filter = null),
                      ),
                      for (final entry in categoryChips.take(6))
                        _CountChip(
                          label: Formatters.categoryLabel(entry.key),
                          count: entry.value,
                          selected: _filter == entry.key,
                          onTap: () => setState(() => _filter = entry.key),
                        ),
                      if (lowStock > 0)
                        _CountChip(
                          label: 'Low stock',
                          count: lowStock,
                          selected: _filter == _lowStockKey,
                          leading: Dot(color: c.rose),
                          onTap: () => setState(() => _filter = _lowStockKey),
                        ),
                    ],
                  ),
                ),
              ),
            //!  <--------- Empty State Section --------->
            //* TO send the user to the home tab when nothing is saved yet
            if (all.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: AppEmptyView(
                    icon: Icons.favorite_border_rounded,
                    title: 'No favorites yet',
                    subtitle: 'Products you heart will show up here.',
                    action: FilledButton.icon(
                      onPressed: () =>
                          Get.find<NavController>().select(NavController.home),
                      icon: Icon(Icons.storefront_outlined, size: 18.r),
                      label: const Text('Browse products'),
                    ),
                  ),
                ),
              )
            else ...[
              //  <--------- Favorites Grid Section --------->
              //* TO show the filtered favorites as two column cards
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    mainAxisExtent: FavoriteCard.height,
                  ),
                  delegate: SliverChildBuilderDelegate((context, i) {
                    final product = visible[i];
                    return FavoriteCard(
                      product: product,
                      onTap: () => Get.toNamed(
                        AppRoutes.productDetailsPath(product.id),
                        arguments: product,
                      ),
                      onRemove: () => _remove(product),
                      onMoveToBag: () => _moveToBag(product),
                    );
                  }, childCount: visible.length),
                ),
              ),
              //  <--------- Summary Bar Section --------->
              //* TO show the in stock total with a move all to bag button
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  child: _SummaryBar(
                    total: inStockTotal,
                    inStockCount: inStock.length,
                    onMoveAll: inStock.isEmpty
                        ? null
                        : () => _moveAllToBag(all),
                  ),
                ),
              ),
            ],
            //  <--------- Recently Viewed Section --------->
            const SliverToBoxAdapter(child: RecentlyViewedRow()),
            SliverToBoxAdapter(child: SizedBox(height: bottomInset)),
          ],
        );
      }),
    );
  }
}

//  <--------- Count Chip Widget --------->
//* TO show a selectable filter chip with a label and a count
class _CountChip extends StatelessWidget {
  const _CountChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  //  <--------- Fields --------->
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.onButton : c.brown;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Center(
        child: Material(
          color: selected ? c.button : c.tint,
          shape: const StadiumBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //  <--------- Leading And Label Section --------->
                  if (leading != null) ...[leading!, SizedBox(width: 6.w)],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.24,
                      color: fg,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  //  <--------- Count Section --------->
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: fg.withValues(alpha: 0.7),
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

//  <--------- Sort Menu Widget --------->
//* TO open a popup with the sort orders behind a round icon button
class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.current, required this.onSelected});

  //  <--------- Fields --------->
  final _FavoritesSort current;
  final ValueChanged<_FavoritesSort> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return PopupMenuButton<_FavoritesSort>(
      tooltip: 'Sort',
      onSelected: onSelected,
      initialValue: current,
      color: c.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      //  <--------- Menu Items Section --------->
      itemBuilder: (context) => [
        for (final s in _FavoritesSort.values)
          PopupMenuItem(value: s, child: Text(s.label)),
      ],
      //  <--------- Trigger Button Section --------->
      child: Container(
        width: 36.r,
        height: 36.r,
        decoration: BoxDecoration(color: c.tint, shape: BoxShape.circle),
        child: Icon(Icons.swap_vert_rounded, size: 16.r, color: c.ink),
      ),
    );
  }
}

//  <--------- Summary Bar Widget --------->
//* TO show the ready to checkout total and a move all to bag button
class _SummaryBar extends StatelessWidget {
  const _SummaryBar({
    required this.total,
    required this.inStockCount,
    required this.onMoveAll,
  });

  //  <--------- Fields --------->
  final double total;
  final int inStockCount;
  final VoidCallback? onMoveAll;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 6.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          //  <--------- Total Section --------->
          //* TO show the in stock total and how many items it covers
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'READY TO CHECKOUT',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.25,
                    color: c.brown,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.price(total),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: c.ink,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '$inStockCount in-stock',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: c.brown,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //  <--------- Move All Button Section --------->
          //* TO disable the button when nothing is in stock
          FilledButton.icon(
            onPressed: onMoveAll,
            style: FilledButton.styleFrom(
              backgroundColor: c.rose,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
            icon: Icon(Icons.shopping_bag_outlined, size: 16.r),
            label: const Text('Move All to Bag'),
          ),
        ],
      ),
    );
  }
}
