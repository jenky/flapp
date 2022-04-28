import 'package:get/get.dart';

import 'api/discussion_provider.dart';
import 'api/tag_provider.dart';
import 'models/entity.dart';
import 'pages/app.dart';
import 'pages/app_controller.dart';
import 'pages/discussion/discussion_controller.dart';
import 'pages/discussion/discussion_page.dart';
import 'pages/home/home_controller.dart';
import 'pages/home/home_page.dart';

final pages = [
  GetPage(
    name: '/',
    page: () => App(),
    binding: BindingsBuilder(() {
      Get.lazyPut<AppController>(() => AppController());
      Get.lazyPut<HomeController>(() => HomeController());
      Get.lazyPut<DiscussionProvider>(() => DiscussionProvider());
      Get.lazyPut<TagProvider>(() => TagProvider());
    })
  ),
];

GetPageRoute homePageRoutes(settings) {
  Get.routing.args = settings.arguments;

  if (settings.name == '/') {
    return GetPageRoute(
      routeName: '/',
      settings: settings,
      page: () => HomePage()
    );
  }

  // Use tag for same page navigation
  if (settings.name == '/d') {
    return GetPageRoute(
      settings: settings,
      page: () => DiscussionPage(),
      binding: BindingsBuilder(() {
        String? tag = settings.arguments is Entity ? 'discussion::${settings.arguments.id}' : null;
        Get.lazyPut<DiscussionController>(() => DiscussionController(),
          tag: tag,
        );
      })
    );
  }

  throw 'Route not found.';
}
