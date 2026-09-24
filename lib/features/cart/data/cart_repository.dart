import '../../../core/storage/local_store.dart';
import 'cart_models.dart';

//  <--------- Cart Repository --------->
//* TO persist the bag so it survives app restarts
class CartRepository {
  CartRepository(this._store);

  //  <--------- Fields --------->
  static const _key = 'cart_lines_v1';

  final LocalStore _store;

  //  <--------- Persistence --------->
  //* TO load saved lines and drop any with a zero quantity
  List<CartLine> load() => _store
      .getJsonObjects(_key, CartLine.fromJson)
      .where((l) => l.quantity > 0)
      .toList();

  //* TO write the current lines to local storage
  Future<void> save(Iterable<CartLine> lines) =>
      _store.setJsonList(_key, lines.map((l) => l.toJson()).toList());
}
