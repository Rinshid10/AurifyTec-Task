import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../core/network/connectivity_controller.dart';
import '../../core/storage/local_store.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/firebase_auth_repository.dart';
import '../../features/cart/controllers/cart_controller.dart';
import '../../features/cart/data/cart_repository.dart';
import '../../features/favorites/controllers/favorites_controller.dart';
import '../../features/favorites/data/favorites_repository.dart';
import '../../features/history/controllers/recently_viewed_controller.dart';
import '../../features/history/data/recently_viewed_repository.dart';
import '../../features/products/controllers/categories_controller.dart';
import '../../features/products/data/products_repository.dart';
import '../../features/settings/controllers/theme_controller.dart';

//  <--------- Initial Binding --------->
//* TO register app-wide services and the controllers that must outlive any single screen
class InitialBinding extends Bindings {
  InitialBinding(this.store);

  final LocalStore store;

  @override
  void dependencies() {
    //  <--------- Infrastructure --------->
    //* TO register the storage and network layers as permanent singletons
    Get.put<LocalStore>(store, permanent: true);
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put(ConnectivityController(), permanent: true);

    //  <--------- Repositories --------->
    //* TO register the data sources every feature reads from
    Get.put<ProductsRepository>(
      ProductsRepository(Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put<AuthRepository>(
      FirebaseAuthRepository(FirebaseAuth.instance),
      permanent: true,
    );
    Get.put<FavoritesRepository>(FavoritesRepository(store), permanent: true);
    Get.put<CartRepository>(CartRepository(store), permanent: true);
    Get.put<RecentlyViewedRepository>(
      RecentlyViewedRepository(store),
      permanent: true,
    );

    //  <--------- Long Lived Controllers --------->
    //* TO keep session, theme, bag, favorites, history and categories alive across screens
    Get.put(ThemeController(store), permanent: true);
    Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);
    Get.put(
      FavoritesController(Get.find<FavoritesRepository>()),
      permanent: true,
    );
    Get.put(CartController(Get.find<CartRepository>()), permanent: true);
    Get.put(
      RecentlyViewedController(Get.find<RecentlyViewedRepository>()),
      permanent: true,
    );
    Get.put(
      CategoriesController(Get.find<ProductsRepository>()),
      permanent: true,
    );
  }
}
