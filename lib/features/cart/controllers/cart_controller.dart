import 'dart:math' as math;

import 'package:get/get.dart';

import '../../products/data/product.dart';
import '../data/cart_models.dart';
import '../data/cart_repository.dart';

//  <--------- Cart Controller --------->
//* TO manage the bag contents and keep them saved on the device
//* TO price lines straight from the products since the API has no promo, shipping or tax
class CartController extends GetxController {
  CartController(this._repository);

  //  <--------- Fields --------->
  static const maxQuantity = 10;

  //* TO cap a line at the stock the API reports, never above the app-wide maximum
  static int limitFor(Product product) =>
      product.stock > 0 ? math.min(maxQuantity, product.stock) : maxQuantity;

  final CartRepository _repository;

  //* TO seed the reactive list from local storage on first access
  late final RxList<CartLine> lines = RxList<CartLine>.of(_repository.load());

  //  <--------- Totals --------->
  bool get isEmpty => lines.isEmpty;

  //* TO count every unit across all lines
  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);

  double get subtotal => lines.fold(0, (sum, l) => sum + l.lineTotal);

  //* TO keep total equal to subtotal because there are no extra charges
  double get total => subtotal;

  //  <--------- Lookup --------->
  //* TO find the quantity of a product or zero when it is not in the bag
  int quantityOf(int productId) {
    for (final l in lines) {
      if (l.product.id == productId) return l.quantity;
    }
    return 0;
  }

  //  <--------- Mutations --------->
  //* TO add a product or bump its quantity and return the new line quantity
  int add(Product product, {int quantity = 1}) {
    final index = lines.indexWhere((l) => l.product.id == product.id);
    final int next;
    if (index == -1) {
      next = quantity.clamp(1, limitFor(product));
      lines.add(CartLine(product: product, quantity: next));
    } else {
      next = (lines[index].quantity + quantity).clamp(1, limitFor(product));
      lines[index] = lines[index].copyWith(quantity: next);
    }
    _persist();
    return next;
  }

  //* TO set an exact quantity and remove the line when it drops to zero
  void setQuantity(int productId, int quantity) {
    if (quantity <= 0) return remove(productId);
    final index = lines.indexWhere((l) => l.product.id == productId);
    if (index == -1) return;
    lines[index] = lines[index].copyWith(
      quantity: quantity.clamp(1, limitFor(lines[index].product)),
    );
    _persist();
  }

  void increment(int productId) =>
      setQuantity(productId, quantityOf(productId) + 1);

  void decrement(int productId) =>
      setQuantity(productId, quantityOf(productId) - 1);

  //!  <--------- Remove Item --------->
  void remove(int productId) {
    lines.removeWhere((l) => l.product.id == productId);
    _persist();
  }

  //!  <--------- Clear All --------->
  //* TO empty the whole bag
  void clear() {
    if (lines.isEmpty) return;
    lines.clear();
    _persist();
  }

  //  <--------- Persistence --------->
  //* TO save in the background and ignore write failures
  void _persist() => _repository.save(lines).catchError((_) {});
}
