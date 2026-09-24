//  <--------- App Routes --------->
//* TO keep route names in one place so views never hard-code strings
abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const shell = '/';
  static const cart = '/cart';
  static const productDetails = '/products/:id';

  //  <--------- Path Builders --------->
  //* TO build a concrete details path for a product id
  static String productDetailsPath(int id) => '/products/$id';
}
