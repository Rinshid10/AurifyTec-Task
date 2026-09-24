import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/section_header.dart';
import '../controllers/categories_controller.dart';
import '../controllers/product_list_controller.dart';
import '../data/product.dart';
import '../data/product_sort.dart';
import '../widgets/explore_widgets.dart';
import '../widgets/list_states.dart';
import 'product_list_view_mixin.dart';

//  <--------- Explore View --------->
//* TO show search with popular tags, category grid, top brands and top rated products, swapping to a results grid when narrowed
class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

//  <--------- Explore View State --------->
class _ExploreViewState extends State<ExploreView> with ProductListViewMixin {
  //  <--------- Constants --------->
  static const _collapsedCategoryCount = 6;
  static const _popularTagCount = 8;
  static const _brandCount = 10;
  static const _topRatedCount = 4;

  //  <--------- Fields --------->
  bool _showAllCategories = false;

  //  <--------- List Binding --------->
  //* TO bind this tab to the explore-scoped product list
  @override
  ProductListController get list =>
      Get.find<ProductListController>(tag: ProductListController.exploreTag);

  //!  <--------- Clear All --------->
  //* TO empty the search field and reset every filter
  void _clearAll() {
    searchController.clear();
    list.resetFilters();
  }

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final categories = Get.find<CategoriesController>();
    final bottomInset = AppBottomNav.contentInset(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: list.reload,
        child: Obx(() {
          final products = list.products;
          return CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              //  <--------- Top Bar Section --------->
              const AppTopBar(title: 'Explore'),
              //  <--------- Search Section --------->
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: ExploreSearchBar(
                    controller: searchController,
                    onChanged: list.setQuery,
                    onClear: _clearAll,
                  ),
                ),
              ),
              //  <--------- Popular Tags Section --------->
              SliverToBoxAdapter(
                child: TrendingRow(
                  terms: _popularTags(products),
                  onTap: search,
                ),
              ),
              //  <--------- Results Section --------->
              //* TO show the results grid when a search, category, brand or tag is active
              if (list.isNarrowed) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: _resultsHeader(c),
                  ),
                ),
                ...productListSlivers(
                  context,
                  list: list,
                  onProductTap: openProduct,
                  horizontalPadding: 16,
                ),
              ] else ...[
                //  <--------- Discovery Sections --------->
                //* TO show categories, brands and top rated when nothing is narrowed
                ..._categorySection(categories, c),
                ..._brandsSection(products),
                ..._topRatedSection(c),
              ],
              //  <--------- Bottom Inset --------->
              SliverToBoxAdapter(child: SizedBox(height: bottomInset)),
            ],
          );
        }),
      ),
    );
  }

  //  <--------- Popular Tags --------->
  //* TO pick the most frequent tags across the loaded products for the suggestion row
  List<String> _popularTags(List<Product> products) {
    final counts = <String, int>{};
    for (final p in products) {
      for (final t in p.tags) {
        counts[t] = (counts[t] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(_popularTagCount).map((e) => e.key).toList();
  }

  //  <--------- Results Header --------->
  //* TO title the results by search query, category or sort label
  Widget _resultsHeader(AppColors c) {
    final total = list.state.value.valueOrNull?.total;
    final parts = [
      if (total != null) '$total items',
      if (list.sort.value != ProductSort.relevance) list.sort.value.label,
    ];
    final title = list.isSearching
        ? 'Results for "${list.query.value}"'
        : list.category.value != null
        ? Formatters.categoryLabel(list.category.value!)
        : list.sort.value.label;
    return SectionHeader(
      title: title,
      titleSize: 18,
      subtitle: parts.isEmpty ? null : parts.join(' · '),
      actionLabel: 'Clear',
      actionColor: c.accent,
      onAction: _clearAll,
      padding: const EdgeInsets.only(bottom: 12),
    );
  }

  //  <--------- Category Section --------->
  //* TO build the Browse by Category header and the collapsible category grid
  List<Widget> _categorySection(CategoriesController categories, AppColors c) {
    final state = categories.categories.value;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: state.when(
            loading: () => const SizedBox.shrink(),
            error: (_) => const SizedBox.shrink(),
            data: (slugs) => SectionHeader(
              title: 'Browse by Category',
              titleSize: 18,
              actionLabel: _showAllCategories
                  ? 'Show less'
                  : '${slugs.length} Categories',
              actionColor: c.brownMuted,
              onAction: () =>
                  setState(() => _showAllCategories = !_showAllCategories),
              padding: const EdgeInsets.only(bottom: 8),
            ),
          ),
        ),
      ),
      //!  <--------- Category Grid States --------->
      //* TO show loading, error with retry, or the grid
      state.when(
        loading: () => const SliverToBoxAdapter(child: InlineLoading()),
        error: (e) => SliverToBoxAdapter(
          child: InlineErrorRow(
            message: ApiException.messageFor(e),
            onRetry: categories.load,
          ),
        ),
        data: (slugs) {
          final visible = _showAllCategories
              ? slugs
              : slugs.take(_collapsedCategoryCount).toList();
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: CategoryGridCard.height,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => CategoryGridCard(
                  slug: visible[i],
                  onTap: () => list.setCategory(visible[i]),
                ),
                childCount: visible.length,
              ),
            ),
          );
        },
      ),
    ];
  }

  //  <--------- Brands Section --------->
  //* TO collect distinct brands from the loaded products and show them as bubbles
  List<Widget> _brandsSection(List<Product> products) {
    final brands = <String>{};
    for (final p in products) {
      final b = p.brand?.trim();
      if (b != null && b.isNotEmpty) brands.add(b);
    }
    if (brands.isEmpty) return const [];
    final names = brands.take(_brandCount).toList();

    return [
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: SectionHeader(
            title: 'Top Brands',
            titleSize: 18,
            subtitle: 'Brands in the loaded catalogue',
            padding: EdgeInsets.only(bottom: 8),
          ),
        ),
      ),
      //  <--------- Brand Strip --------->
      //* TO size the strip as 64 circle + 8 gap + 17 label + 8 list padding
      SliverToBoxAdapter(
        child: SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: names.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) => BrandBubble(
              name: names[i],
              accent: i.isOdd,
              onTap: () => search(names[i]),
            ),
          ),
        ),
      ),
    ];
  }

  //  <--------- Top Rated Section --------->
  //* TO show the four highest rated products from the loaded list
  List<Widget> _topRatedSection(AppColors c) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: SectionHeader(
            title: 'Top Rated',
            titleSize: 18,
            subtitle: 'Highest customer ratings',
            actionLabel: 'See all',
            actionColor: c.accent,
            onAction: () => list.setSort(ProductSort.topRated),
            padding: const EdgeInsets.only(bottom: 8),
          ),
        ),
      ),
      //!  <--------- Top Rated States --------->
      //* TO show loading, error with retry, or the grid
      list.state.value.when(
        loading: () => const SliverToBoxAdapter(child: InlineLoading()),
        error: (e) => SliverToBoxAdapter(
          child: InlineErrorRow(
            message: ApiException.messageFor(e),
            onRetry: list.reload,
          ),
        ),
        data: (data) {
          final best = [...data.products]
            ..sort((a, b) => b.rating.compareTo(a.rating));
          final top = best.take(_topRatedCount).toList();
          return SliverLayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.crossAxisExtent - 32 - 8) / 2;
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: tileWidth + TopRatedCard.textBlockHeight,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => TopRatedCard(
                      product: top[i],
                      badge: i == 0 ? 'Top rated' : null,
                      onTap: () => openProduct(top[i]),
                    ),
                    childCount: top.length,
                  ),
                ),
              );
            },
          );
        },
      ),
    ];
  }
}
