import 'package:get/get.dart';

import '../../products/data/product.dart';
import '../data/favorites_repository.dart';

//  <--------- Favorites Controller --------->
//* TO keep favorites in memory keyed by product id with insertion order preserved
//* TO write every change through to local storage
class FavoritesController extends GetxController {
  FavoritesController(this._repository);

  //  <--------- Fields --------->
  final FavoritesRepository _repository;

  //* TO seed the reactive map from local storage on first access
  late final RxMap<int, Product> items = RxMap<int, Product>.of({
    for (final p in _repository.load()) p.id: p,
  });

  //  <--------- Lookup --------->
  int get count => items.length;

  List<Product> get products => items.values.toList();

  bool isFavorite(int id) => items.containsKey(id);

  //  <--------- Mutations --------->
  //* TO add or remove a product and return true when it was added
  bool toggle(Product product) {
    final added = !items.containsKey(product.id);
    if (added) {
      items[product.id] = product;
    } else {
      items.remove(product.id);
    }
    _persist();
    return added;
  }

  //!  <--------- Remove Item --------->
  //* TO save only when something was actually removed
  //  <--------- Add --------->
  //* TO add a product without toggling, so an Undo cannot remove something re-favorited in the meantime
  void add(Product product) {
    if (items.containsKey(product.id)) return;
    items[product.id] = product;
    _persist();
  }

  void remove(int id) {
    if (items.remove(id) != null) _persist();
  }

  //!  <--------- Clear All --------->
  void clear() {
    if (items.isEmpty) return;
    items.clear();
    _persist();
  }

  //  <--------- Persistence --------->
  //* TO save in the background since a failed write only affects the next launch
  void _persist() {
    _repository.save(items.values).catchError((_) {});
  }
}
