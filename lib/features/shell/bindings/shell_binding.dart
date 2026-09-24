import 'package:get/get.dart';

import '../../products/controllers/product_list_controller.dart';
import '../../products/data/products_repository.dart';
import '../controllers/nav_controller.dart';

//  <--------- Shell Binding --------->
//* TO register the controllers that live as long as the tab shell
class ShellBinding extends Bindings {
  @override
  void dependencies() {
    //  <--------- Nav Controller --------->
    Get.put(NavController());
    //  <--------- Product List Controllers --------->
    //* TO create one list controller per tab tag for home and explore
    for (final tag in [
      ProductListController.homeTag,
      ProductListController.exploreTag,
    ]) {
      Get.put(ProductListController(Get.find<ProductsRepository>()), tag: tag);
    }
  }
}
