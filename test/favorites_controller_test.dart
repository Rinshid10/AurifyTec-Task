import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/core/storage/local_store.dart';
import 'package:product_explorer/features/favorites/controllers/favorites_controller.dart';
import 'package:product_explorer/features/favorites/data/favorites_repository.dart';
import 'package:product_explorer/features/products/data/product.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Product _product(int id) => Product.fromJson({'id': id, 'title': 'P$id'});

/// A fresh controller over the same in-memory backend behaves like the app
/// being restarted.
Future<FavoritesController> _controller() async {
  final store = await LocalStore.create();
  return FavoritesController(FavoritesRepository(store));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('starts empty', () async {
    final favorites = await _controller();
    expect(favorites.items, isEmpty);
    expect(favorites.count, 0);
  });

  test('toggle adds then removes', () async {
    final favorites = await _controller();

    expect(favorites.toggle(_product(1)), isTrue);
    expect(favorites.isFavorite(1), isTrue);

    expect(favorites.toggle(_product(1)), isFalse);
    expect(favorites.isFavorite(1), isFalse);
  });

  test('favorites persist across restarts', () async {
    final first = await _controller();
    first.toggle(_product(1));
    first.toggle(_product(2));
    // Let the fire-and-forget write complete.
    await Future<void>.delayed(Duration.zero);

    final second = await _controller();
    expect(second.items.keys, [1, 2]);
    expect(second.items[2]!.title, 'P2');
  });

  test('remove is a no-op for unknown ids', () async {
    final favorites = await _controller();
    favorites.toggle(_product(1));
    favorites.remove(99);
    expect(favorites.items.keys, [1]);
  });

  test('clear empties the list and storage', () async {
    final first = await _controller();
    first.toggle(_product(1));
    first.clear();
    await Future<void>.delayed(Duration.zero);

    final second = await _controller();
    expect(second.items, isEmpty);
  });
}
