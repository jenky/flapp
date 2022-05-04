import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

import '../routes.dart' as route;
import 'app_controller.dart';
import 'home/home_controller.dart';
import 'home/discussions_page.dart';
import 'home/tags_page.dart';
import 'settings/settings_page.dart';

class App extends GetView<AppController> {

  @override
  Widget build(BuildContext context) {
    return ScrollsToTop(
      onScrollsToTop: _onScrollsToTop,
      child: PersistentTabView(
        context,
        controller: controller.tabController,
        screens: _buildScreens(),
        items: _navBarsItems(),
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      DiscussionsPage(),
      TagsPage(),
      SettingsPage(),
      SettingsPage(),
      SettingsPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
        inactiveIcon: const Icon(CupertinoIcons.chat_bubble_2),
        title: ('Discussions'),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: route.discussionsPageRoutes,
          navigatorKey: Get.nestedKey(0),
          navigatorObservers: [GetObserver()],
        ),
        onSelectedTabPressWhenNoScreensPushed: () => Get.find<HomeController>().scrollToTop()
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.square_grid_2x2_fill),
        inactiveIcon: const Icon(CupertinoIcons.square_grid_2x2),
        title: ('Tags'),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: route.tagsPageRoutes,
          navigatorKey: Get.nestedKey(1),
          navigatorObservers: [GetObserver()],
        ),
        // onSelectedTabPressWhenNoScreensPushed: () {}
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.plus),
        title: ('Add'),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        // onSelectedTabPressWhenNoScreensPushed: () {}
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell_fill),
        inactiveIcon: const Icon(CupertinoIcons.bell),
        title: ('Notifications'),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        // onSelectedTabPressWhenNoScreensPushed: () {}
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_crop_circle_fill),
        inactiveIcon: const Icon(CupertinoIcons.person_crop_circle),
        title: ('Profile'),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        // onSelectedTabPressWhenNoScreensPushed: () {}
      ),
    ];
  }

  Future<void> _onScrollsToTop(ScrollsToTopEvent event) async {
    switch (controller.tabController.index) {
      case 1:
        Get.find<HomeController>().scrollToTop();
      break;
    }
  }
}
