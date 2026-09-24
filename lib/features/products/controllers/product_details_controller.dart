import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../../core/state/async_state.dart';
import '../../history/controllers/recently_viewed_controller.dart';
import '../data/product.dart';
import '../data/products_repository.dart';

//  <--------- Product Details Controller --------->
//* TO load one product by id and show the list item immediately while the fresh copy loads
class ProductDetailsController extends GetxController {
  ProductDetailsController(this._repository, {required this.id, this.initial});

  //  <--------- Fields --------->
  final ProductsRepository _repository;
  final int id;
  final Product? initial;

  final state = Rx<AsyncState<Product>>(const AsyncState.loading());

  //  <--------- Product Getter --------->
  //* TO return fresh data when available otherwise the product from the list
  Product? get product => state.value.valueOrNull ?? initial;

  bool _recorded = false;

  //  <--------- Lifecycle --------->
  //* TO wait until the first frame finishes, because this controller is created inside the details build and writing history there marks an Obx that is already on screen
  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      if (initial != null) _recordView(initial!);
      load();
    });
  }

  //  <--------- Loading --------->
  //* TO fetch the product and record the view, keeping what is already on screen while refreshing
  Future<void> load() async {
    if (state.value.valueOrNull == null) {
      state.value = const AsyncState.loading();
    }
    try {
      final product = await _repository.getProduct(id);
      state.value = AsyncState.data(product);
      _recordView(product);
    } catch (e) {
      state.value = AsyncState.error(e);
    }
  }

  //  <--------- Helpers --------->
  //* TO add the product to recently viewed only once
  void _recordView(Product product) {
    if (_recorded) return;
    _recorded = true;
    Get.find<RecentlyViewedController>().add(product);
  }
}
