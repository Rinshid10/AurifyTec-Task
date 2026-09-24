import 'dart:async';

import 'package:get/get.dart';

import '../../../core/state/async_state.dart';
import '../data/product.dart';
import '../data/product_sort.dart';
import '../data/products_repository.dart';

//  <--------- Product List State --------->
//* TO hold the loaded page plus pagination bookkeeping
class ProductListState {
  const ProductListState({
    required this.products,
    required this.total,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<Product> products;
  final int total;
  final bool isLoadingMore;
  final String? loadMoreError;

  bool get hasMore => products.length < total;

  //  <--------- Copy --------->
  //* TO clone the state with selected fields replaced
  ProductListState copyWith({
    List<Product>? products,
    int? total,
    bool? isLoadingMore,
    String? Function()? loadMoreError,
  }) {
    return ProductListState(
      products: products ?? this.products,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError != null
          ? loadMoreError()
          : this.loadMoreError,
    );
  }
}

//  <--------- Product List Controller --------->
//* TO manage a paginated filterable product list, one per tab so searching on one never disturbs the other
class ProductListController extends GetxController {
  ProductListController(this._repository);

  //  <--------- Constants --------->
  static const homeTag = 'home';
  static const exploreTag = 'explore';
  static const debounceDuration = Duration(milliseconds: 400);

  //  <--------- Fields --------->
  final ProductsRepository _repository;

  final state = Rx<AsyncState<ProductListState>>(const AsyncState.loading());
  final query = ''.obs;
  final category = Rxn<String>();
  final sort = ProductSort.relevance.obs;

  Timer? _debounce;
  int _requestId = 0;

  //  <--------- Getters --------->
  //* TO expose the current search and filter status
  bool get isSearching => query.value.trim().isNotEmpty;

  bool get hasActiveFilter =>
      category.value != null || sort.value != ProductSort.relevance;

  bool get isNarrowed => isSearching || hasActiveFilter;

  List<Product> get products =>
      state.value.valueOrNull?.products ?? const <Product>[];

  //  <--------- Lifecycle --------->
  @override
  void onInit() {
    super.onInit();
    reload();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  //  <--------- Filters --------->
  //* TO debounce typed input and apply suggestions and submits immediately
  void setQuery(String value, {bool immediate = false}) {
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed == query.value) return;
    if (trimmed.isEmpty || immediate) {
      _applyQuery(trimmed);
      return;
    }
    _debounce = Timer(debounceDuration, () => _applyQuery(trimmed));
  }

  void clearQuery() => setQuery('', immediate: true);

  //* TO drop the category when a search starts, because the search endpoint cannot filter by category
  void _applyQuery(String value) {
    query.value = value;
    if (value.isNotEmpty) category.value = null;
    reload();
  }

  //  <--------- Category Filter --------->
  //* TO reset the query when picking a category since category and search are mutually exclusive on DummyJSON
  void setCategory(String? value) {
    _debounce?.cancel();
    query.value = '';
    category.value = value;
    reload();
  }

  //  <--------- Sort Filter --------->
  void setSort(ProductSort value) {
    if (value == sort.value) return;
    sort.value = value;
    reload();
  }

  //!  <--------- Reset Filters --------->
  //* TO clear the query, category and sort back to defaults and reload
  void resetFilters() {
    _debounce?.cancel();
    query.value = '';
    category.value = null;
    sort.value = ProductSort.relevance;
    reload();
  }

  //  <--------- Loading --------->
  //* TO reload the first page on initial load, filter change, retry and pull-to-refresh
  Future<void> reload() async {
    final id = ++_requestId;
    state.value = const AsyncState.loading();
    try {
      final page = await _fetchPage(skip: 0);
      //!  <--------- Stale Request Guard --------->
      //* TO ignore responses from earlier calls
      if (id != _requestId) return;
      state.value = AsyncState.data(
        ProductListState(products: page.products, total: page.total),
      );
    } catch (e) {
      if (id != _requestId) return;
      state.value = AsyncState.error(e);
    }
  }

  //  <--------- Load More --------->
  //* TO fetch the next page and append it while keeping errors separate so the loaded list stays on screen
  Future<void> loadMore({bool retry = false}) async {
    final current = state.value.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;
    //!  <--------- Failed Page Guard --------->
    //* TO stop scroll bounces from re-firing a failed request; only the footer Retry passes retry
    if (current.loadMoreError != null && !retry) return;

    final id = _requestId;
    state.value = AsyncState.data(
      current.copyWith(isLoadingMore: true, loadMoreError: () => null),
    );
    try {
      final page = await _fetchPage(skip: current.products.length);
      //!  <--------- Stale Request Guard --------->
      //* TO drop the page if the list was reloaded meanwhile
      if (id != _requestId) return;
      state.value = AsyncState.data(
        current.copyWith(
          products: [...current.products, ...page.products],
          total: page.total,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (id != _requestId) return;
      state.value = AsyncState.data(
        current.copyWith(
          isLoadingMore: false,
          loadMoreError: () => e.toString(),
        ),
      );
    }
  }

  //  <--------- Helpers --------->
  //* TO pick the search or listing endpoint for the current filters
  Future<ProductPage> _fetchPage({required int skip}) {
    if (isSearching) {
      return _repository.searchProducts(
        query.value,
        skip: skip,
        sort: sort.value,
      );
    }
    return _repository.getProducts(
      skip: skip,
      category: category.value,
      sort: sort.value,
    );
  }
}
