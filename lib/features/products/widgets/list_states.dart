import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_state_views.dart';
import '../controllers/product_list_controller.dart';
import '../data/product.dart';
import 'product_grid.dart';

//  <--------- Product List Slivers --------->
//* TO build the loading, error, empty or grid plus footer slivers shared by Home and Explore
List<Widget> productListSlivers(
  BuildContext context, {
  required ProductListController list,
  required ValueChanged<Product> onProductTap,
  double horizontalPadding = 24,
}) {
  return list.state.value.when(
    //  <--------- Loading --------->
    loading: () => const [
      SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: AppLoadingView(),
        ),
      ),
    ],
    //!  <--------- Error --------->
    //* TO show the error view with a retry
    error: (error) => [
      SliverFillRemaining(
        hasScrollBody: false,
        child: AppErrorView(
          message: ApiException.messageFor(error),
          onRetry: list.reload,
        ),
      ),
    ],
    //  <--------- Data --------->
    //* TO show the empty view or the grid with a load-more footer
    data: (data) {
      if (data.products.isEmpty) {
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyList(list: list),
          ),
        ];
      }
      return [
        ProductSliverGrid(
          products: data.products,
          onProductTap: onProductTap,
          horizontalPadding: horizontalPadding,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12,
              horizontalPadding,
              8,
            ),
            child: ListFooter(
              data: data,
              onLoadMore: () => list.loadMore(retry: true),
            ),
          ),
        ),
      ];
    },
  );
}

//  <--------- Empty List Widget --------->
//* TO show a no-results or no-products message with a clear or refresh action
class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.list});

  final ProductListController list;

  @override
  Widget build(BuildContext context) {
    if (list.isSearching) {
      return AppEmptyView(
        icon: Icons.search_off_rounded,
        title: 'No results for "${list.query.value}"',
        subtitle: 'Try a different keyword or check the spelling.',
        action: OutlinedButton(
          onPressed: list.clearQuery,
          child: const Text('Clear search'),
        ),
      );
    }
    return AppEmptyView(
      icon: Icons.storefront_outlined,
      title: 'No products available',
      subtitle: list.category.value != null
          ? 'This category is empty right now.'
          : 'Pull down to refresh or try again later.',
      action: FilledButton.tonal(
        onPressed: list.reload,
        child: const Text('Refresh'),
      ),
    );
  }
}

//  <--------- List Footer Widget --------->
//* TO show the load-more spinner, retry row or all caught up line under a grid
class ListFooter extends StatelessWidget {
  const ListFooter({super.key, required this.data, required this.onLoadMore});

  final ProductListState data;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    //  <--------- Loading More --------->
    if (data.isLoadingMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    //!  <--------- Load More Error --------->
    //* TO offer a retry without dropping the loaded list
    if (data.loadMoreError != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Could not load more products.',
            style: TextStyle(fontSize: 12, color: c.brown),
          ),
          TextButton.icon(
            onPressed: onLoadMore,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
          ),
        ],
      );
    }
    //  <--------- All Caught Up --------->
    if (!data.hasMore) {
      return Center(
        child: Text(
          "You're all caught up · ${data.products.length} products",
          style: TextStyle(fontSize: 11, color: c.muted),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
