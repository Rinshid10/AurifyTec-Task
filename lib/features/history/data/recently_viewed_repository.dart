import '../../../core/storage/local_store.dart';
import '../../products/data/product.dart';

//  <--------- Recently Viewed Repository --------->
//* TO persist the last few opened products with the most recent first
class RecentlyViewedRepository {
  RecentlyViewedRepository(this._store);

  //  <--------- Fields --------->
  static const _key = 'recently_viewed_v1';

  final LocalStore _store;

  //  <--------- Persistence --------->
  List<Product> load() => _store.getJsonObjects(_key, Product.fromJson);

  Future<void> save(Iterable<Product> products) =>
      _store.setJsonList(_key, products.map((p) => p.toJson()).toList());
}
