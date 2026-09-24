import 'package:get/get.dart';

import '../../products/data/product.dart';
import '../data/recently_viewed_repository.dart';

//  <--------- Recently Viewed Controller --------->
//* TO keep a most recent first list of opened products capped at maxItems
class RecentlyViewedController extends GetxController {
  RecentlyViewedController(this._repository);

  //  <--------- Fields --------->
  static const maxItems = 12;

  final RecentlyViewedRepository _repository;

  //* TO seed the reactive list from local storage on first access
  late final RxList<Product> items = RxList<Product>.of(_repository.load());

  //  <--------- Mutations --------->
  //* TO move a product to the front, drop its older entry and trim to the cap
  void add(Product product) {
    final next = [product, ...items.where((p) => p.id != product.id)];
    items.assignAll(next.take(maxItems));
    _persist();
  }

  //!  <--------- Clear All --------->
  void clear() {
    if (items.isEmpty) return;
    items.clear();
    _persist();
  }

  //  <--------- Persistence --------->
  //* TO save in the background and ignore write failures
  void _persist() => _repository.save(items).catchError((_) {});
}
