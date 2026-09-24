import 'package:get/get.dart';

import '../../../core/state/async_state.dart';
import '../data/product.dart';
import '../data/products_repository.dart';

//  <--------- Categories Controller --------->
//* TO hold category slugs plus lazily fetched per-category facts shared by the chips, the filter sheet and the Explore grid
class CategoriesController extends GetxController {
  CategoriesController(this._repository);

  //  <--------- Fields --------->
  final ProductsRepository _repository;

  final categories = Rx<AsyncState<List<String>>>(const AsyncState.loading());
  final summaries = RxMap<String, AsyncState<CategorySummary>>();

  //  <--------- Pending Fetches --------->
  //* TO track slugs whose summary fetch has been scheduled but not stored yet
  final _pending = <String>{};

  //  <--------- Lifecycle --------->
  @override
  void onInit() {
    super.onInit();
    load();
  }

  //  <--------- Loading --------->
  //* TO fetch the category slugs
  Future<void> load() async {
    categories.value = const AsyncState.loading();
    try {
      categories.value = AsyncState.data(await _repository.getCategories());
    } catch (e) {
      categories.value = AsyncState.error(e);
    }
  }

  //  <--------- Category Summary --------->
  //* TO return the cached summary and kick off a fetch the first time a category is asked for
  AsyncState<CategorySummary> summaryOf(String slug) {
    final cached = summaries[slug];
    if (cached != null) return cached;
    if (_pending.add(slug)) {
      //!  <--------- Deferred Fetch --------->
      //* TO schedule after this call returns since writing the map here would notify Obx listeners mid-build
      Future.microtask(() {
        if (!isClosed) _loadSummary(slug);
      });
    }
    return const AsyncState.loading();
  }

  //  <--------- Helpers --------->
  //* TO fetch one summary and store it unless the controller was closed
  Future<void> _loadSummary(String slug) async {
    try {
      final summary = await _repository.getCategorySummary(slug);
      if (isClosed) return;
      summaries[slug] = AsyncState.data(summary);
    } catch (e) {
      if (isClosed) return;
      summaries[slug] = AsyncState.error(e);
    }
  }
}
