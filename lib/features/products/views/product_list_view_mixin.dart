import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes.dart';
import '../controllers/product_list_controller.dart';
import '../data/product.dart';

//  <--------- Product List View Mixin --------->
//* TO share pagination scrolling, search field sync and details navigation between tabs that show a product list
mixin ProductListViewMixin<T extends StatefulWidget> on State<T> {
  //  <--------- List Binding --------->
  //* TO name which list this view is bound to
  ProductListController get list;

  //  <--------- Fields --------->
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  Worker? _querySync;

  static const _loadMoreThreshold = 300.0;

  //  <--------- Lifecycle --------->
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_maybeLoadMore);
    searchController.text = list.query.value;
    //  <--------- Query Sync --------->
    //* TO empty the field when the query is reset elsewhere like picking a category or Clear
    _querySync = ever(list.query, (String q) {
      if (q.isEmpty && searchController.text.isNotEmpty) {
        searchController.clear();
      }
    });
  }

  @override
  void dispose() {
    _querySync?.dispose();
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  //  <--------- Pagination --------->
  //* TO load the next page when scrolled near the bottom
  void _maybeLoadMore() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      list.loadMore();
    }
  }

  //  <--------- Search --------->
  //* TO apply a term immediately from suggestion chips and brand bubbles
  void search(String term) {
    searchController.text = term;
    list.setQuery(term, immediate: true);
  }

  //!  <--------- Clear Search --------->
  void clearSearch() {
    searchController.clear();
    list.clearQuery();
  }

  //  <--------- Navigation --------->
  //* TO open details passing the list item so it shows instantly
  void openProduct(Product product) {
    Get.toNamed(AppRoutes.productDetailsPath(product.id), arguments: product);
  }
}
