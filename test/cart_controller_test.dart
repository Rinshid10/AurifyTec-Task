import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/core/storage/local_store.dart';
import 'package:product_explorer/features/cart/controllers/cart_controller.dart';
import 'package:product_explorer/features/cart/data/cart_repository.dart';
import 'package:product_explorer/features/products/data/product.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Product _product(int id, {double price = 10, int stock = 5}) =>
    Product.fromJson({
      'id': id,
      'title': 'P$id',
      'price': price,
      'stock': stock,
    });

Future<CartController> _controller() async {
  final store = await LocalStore.create();
  return CartController(CartRepository(store));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('add merges quantities and caps at the maximum', () async {
    final cart = await _controller();
    final plenty = _product(1, stock: 50);

    expect(cart.add(plenty), 1);
    expect(cart.add(plenty, quantity: 2), 3);
    expect(cart.add(plenty, quantity: 99), CartController.maxQuantity);
    expect(cart.itemCount, CartController.maxQuantity);
    expect(cart.lines.length, 1);
  });

  test('quantity never exceeds the product stock', () async {
    final cart = await _controller();
    final scarce = _product(2, stock: 2);

    expect(CartController.limitFor(scarce), 2);
    expect(cart.add(scarce, quantity: 5), 2);
    cart.increment(2);
    expect(cart.quantityOf(2), 2);
  });

  test('decrement to zero removes the line', () async {
    final cart = await _controller();
    cart.add(_product(1));
    cart.decrement(1);
    expect(cart.isEmpty, isTrue);
  });

  test('subtotal and total come straight from line prices', () async {
    final cart = await _controller();
    cart.add(_product(1, price: 20), quantity: 2);
    cart.add(_product(2, price: 15));

    expect(cart.itemCount, 3);
    expect(cart.subtotal, 55);
    expect(cart.total, 55);
    expect(cart.quantityOf(1), 2);
    expect(cart.quantityOf(3), 0);
  });

  test('bag persists across restarts; clear wipes it', () async {
    final first = await _controller();
    first.add(_product(7), quantity: 3);
    await Future<void>.delayed(Duration.zero);

    final second = await _controller();
    expect(second.lines.single.quantity, 3);
    expect(second.lines.single.product.title, 'P7');

    second.clear();
    await Future<void>.delayed(Duration.zero);
    final third = await _controller();
    expect(third.isEmpty, isTrue);
  });
}
