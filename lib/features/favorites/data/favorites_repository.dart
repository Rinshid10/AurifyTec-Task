import '../../../core/storage/local_store.dart';
import '../../products/data/product.dart';

//  <--------- Favorites Repository --------->
//* TO persist favorite products locally
//* TO store the full product so the favorites screen renders instantly and offline
class FavoritesRepository {
  FavoritesRepository(this._store);

  //  <--------- Fields --------->
  static const _key = 'favorites_v1';

  final LocalStore _store;

  //  <--------- Persistence --------->
  List<Product> load() => _store.getJsonObjects(_key, Product.fromJson);

  Future<void> save(Iterable<Product> products) =>
      _store.setJsonList(_key, products.map((p) => p.toJson()).toList());
}
