import 'package:get/get.dart';

import '../../../app/routes.dart';

//  <--------- Nav Controller --------->
//* TO track which bottom tab is showing since tabs are not routes and pushed screens sit above the shell
class NavController extends GetxController {
  //  <--------- Tab Indexes --------->
  static const home = 0;
  static const explore = 1;
  static const favorites = 2;
  static const profile = 3;

  //  <--------- Selected Tab --------->
  final index = home.obs;

  void select(int tab) => index.value = tab;

  //!  <--------- Go To Tab --------->
  //* TO pop any pushed screens and switch to the given tab
  void goToTab(int tab) {
    index.value = tab;
    Get.until((route) => route.settings.name == AppRoutes.shell);
  }
}
