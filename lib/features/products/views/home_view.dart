import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/section_header.dart';
import '../../shell/controllers/nav_controller.dart';
import '../controllers/product_list_controller.dart';
import '../data/product.dart';
import '../data/product_sort.dart';
import '../widgets/category_chips.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/home_header.dart';
import '../widgets/list_states.dart';
import '../widgets/product_grid.dart';
import '../widgets/promo_banner.dart';
import 'product_list_view_mixin.dart';

//  <--------- Home View --------->
//* TO show greeting, search, hero carousel, category chips, Top Deals and the product grid, collapsing to just results while searching
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

//  <--------- Home View State --------->
class _HomeViewState extends State<HomeView> with ProductListViewMixin {
  //  <--------- Constants --------->
  static const _dealCount = 8;
  static const _heroCount = 3;

  //  <--------- List Binding --------->
  //* TO bind this tab to the home-scoped product list
  @override
  ProductListController get list =>
      Get.find<ProductListController>(tag: ProductListController.homeTag);

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottomInset = AppBottomNav.contentInset(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: list.reload,
          child: Obx(() {
            final showDiscovery = !list.isSearching;
            final deals = _topDeals(list.products);
            final showDeals =
                showDiscovery &&
                list.category.value == null &&
                deals.isNotEmpty;
            return CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                //  <--------- Header Section --------->
                SliverToBoxAdapter(
                  child: HomeHeader(
                    searchController: searchController,
                    onSearchChanged: list.setQuery,
                    onSearchCleared: clearSearch,
                    onFilterTap: () => FilterSheet.show(list),
                    filterActive: list.hasActiveFilter,
                  ),
                ),
                //  <--------- Hero Carousel Section --------->
                //* TO show the discovery sections only when not searching
                if (showDiscovery) ...[
                  if (deals.isNotEmpty)
                    SliverToBoxAdapter(
                      child: PromoCarousel(slides: _slides(deals)),
                    ),
                  //  <--------- Category Chips Section --------->
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: CategoryChips(list: list),
                    ),
                  ),
                ],
                //  <--------- Top Deals Section --------->
                //* TO show the biggest discounts only when no category is selected
                if (showDeals) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: SectionHeader(
                        title: 'Top Deals',
                        subtitle: 'Biggest discounts in the catalogue',
                        actionLabel: 'See all',
                        onAction: () =>
                            list.setSort(ProductSort.biggestDiscount),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ProductCarousel(
                      products: deals,
                      onProductTap: openProduct,
                    ),
                  ),
                ],
                //  <--------- Product Grid Section --------->
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: _sectionTitle(c),
                  ),
                ),
                ...productListSlivers(
                  context,
                  list: list,
                  onProductTap: openProduct,
                ),
                //  <--------- Bottom Inset --------->
                //* TO keep the last row clear of the bottom nav
                SliverToBoxAdapter(child: SizedBox(height: bottomInset)),
              ],
            );
          }),
        ),
      ),
    );
  }

  //  <--------- Top Deals --------->
  //* TO pick the highest discounts among what is already loaded with no extra request
  List<Product> _topDeals(List<Product> products) {
    if (products.length < 4) return const [];
    final sorted = [...products]
      ..sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
    return sorted.take(_dealCount).toList();
  }

  //  <--------- Hero Slides --------->
  //* TO build hero slides straight from the top discounted products so every headline, percentage and photo is real catalogue data
  List<PromoSlide> _slides(List<Product> deals) {
    return [
      for (final p in deals.take(_heroCount))
        PromoSlide(
          tag: Formatters.categoryLabel(p.category),
          title: p.title,
          lead: 'Save ',
          highlight: Formatters.discount(p.discountPercentage).substring(1),
          trail:
              ' · now ${Formatters.price(p.finalPrice)}, was ${Formatters.price(p.price)}',
          actionLabel: 'View product',
          onAction: () => openProduct(p),
          imageUrl: p.thumbnail.isEmpty ? null : p.thumbnail,
        ),
    ];
  }

  //  <--------- Section Title --------->
  //* TO pick the grid heading and action for search, category or default browsing
  Widget _sectionTitle(AppColors c) {
    final total = list.state.value.valueOrNull?.total;
    final parts = [
      if (total != null) '$total items',
      if (list.sort.value != ProductSort.relevance) list.sort.value.label,
    ];
    final subtitle = parts.isEmpty ? null : parts.join(' · ');

    if (list.isSearching) {
      return SectionHeader(
        title: 'Results for "${list.query.value}"',
        subtitle: subtitle,
        actionLabel: 'Clear',
        actionColor: c.ink,
        onAction: clearSearch,
      );
    }
    if (list.category.value != null) {
      return SectionHeader(
        title: Formatters.categoryLabel(list.category.value!),
        subtitle: subtitle,
        actionLabel: 'All items',
        actionColor: c.ink,
        onAction: () => list.setCategory(null),
      );
    }
    final sorted = list.sort.value != ProductSort.relevance;
    return SectionHeader(
      title: 'All Products',
      subtitle: subtitle,
      actionLabel: sorted ? 'Reset' : 'Explore',
      actionColor: c.ink,
      onAction: sorted
          ? () => list.setSort(ProductSort.relevance)
          : () => Get.find<NavController>().select(NavController.explore),
    );
  }
}
