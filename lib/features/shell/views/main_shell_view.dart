import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../favorites/views/favorites_view.dart';
import '../../products/views/explore_view.dart';
import '../../products/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/nav_controller.dart';

//  <--------- Main Shell View --------->
//* TO hold the four tabs in an IndexedStack so each keeps its scroll position
class MainShellView extends GetView<NavController> {
  const MainShellView({super.key});

  //  <--------- Tabs --------->
  static const _tabs = [
    HomeView(),
    ExploreView(),
    FavoritesView(),
    ProfileView(),
  ];

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //  <--------- Tab Stack Section --------->
      //* TO let only the visible tab take part in hero animations
      body: Obx(() {
        final index = controller.index.value;
        return IndexedStack(
          index: index,
          children: [
            for (var i = 0; i < _tabs.length; i++)
              HeroMode(enabled: i == index, child: _tabs[i]),
          ],
        );
      }),
      //  <--------- Bottom Nav Section --------->
      bottomNavigationBar: Obx(
        () => AppBottomNav(
          currentIndex: controller.index.value,
          onSelected: controller.select,
        ),
      ),
    );
  }
}
