import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  //  <--------- Design Size --------->
  //* TO scale every .w .h .sp .r value from the 390 x 844 Figma frame to the real screen
  static const designSize = Size(390, 844);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
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
      ),
    );
  }
}
