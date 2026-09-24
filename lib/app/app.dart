import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/storage/local_store.dart';
import '../features/settings/controllers/theme_controller.dart';
import 'app_pages.dart';
import 'bindings/initial_binding.dart';
import 'routes.dart';
import 'theme.dart';

//  <--------- Sell Store App --------->
//* TO wire themes, dependency bindings and the GetX route table at the root
class ProductExplorerApp extends StatelessWidget {
  const ProductExplorerApp({super.key, required this.store});

  final LocalStore store;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sell Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(store),
      initialRoute: AppRoutes.shell,
      getPages: AppPages.pages,
      //  <--------- Persisted Theme --------->
      //* TO apply the saved theme mode once the controller exists
      onReady: () =>
          Get.changeThemeMode(Get.find<ThemeController>().mode.value),
    );
  }
}
