import 'package:get/get.dart';

import '../features/auth/bindings/auth_bindings.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/register_view.dart';
import '../features/cart/views/cart_view.dart';
import '../features/products/bindings/product_details_binding.dart';
import '../features/products/views/product_details_view.dart';
import '../features/shell/bindings/shell_binding.dart';
import '../features/shell/views/main_shell_view.dart';
import 'middleware/auth_middleware.dart';
import 'routes.dart';

//  <--------- App Pages --------->
//* TO define the route table; tab screens live inside the shell while details and cart are pushed on top of it
abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    //  <--------- Auth Routes --------->
    //* TO show login and register only to guests
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      middlewares: [GuestGuard()],
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      middlewares: [GuestGuard()],
    ),
    //  <--------- Signed In Routes --------->
    //* TO protect the shell, product details and cart behind the auth guard
    GetPage(
      name: AppRoutes.shell,
      page: () => const MainShellView(),
      binding: ShellBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      middlewares: [AuthGuard()],
    ),
  ];
}
