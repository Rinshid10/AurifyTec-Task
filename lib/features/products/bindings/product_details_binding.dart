import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';
import '../data/product.dart';
import '../data/products_repository.dart';

//  <--------- Product Details Binding --------->
//* TO register one controller per opened product, tagged by id so details can be pushed on top of details
class ProductDetailsBinding extends Bindings {
  //  <--------- Tag --------->
  //* TO build the controller tag for a product id
  static String tagFor(int id) => 'product-$id';

  //  <--------- Dependencies --------->
  //* TO read the id from the route and pass the list item as the initial product when available
  @override
  void dependencies() {
    final id = int.tryParse(Get.parameters['id'] ?? '') ?? -1;
    Get.lazyPut(
      () => ProductDetailsController(
        Get.find<ProductsRepository>(),
        id: id,
        initial: Get.arguments is Product ? Get.arguments as Product : null,
      ),
      tag: tagFor(id),
    );
  }
}
