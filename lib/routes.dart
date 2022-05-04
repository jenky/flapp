import 'package:get/get.dart';

import 'api/discussion_provider.dart';
import 'api/tag_provider.dart';
import 'models/entity.dart';
import 'pages/app.dart';
import 'pages/app_controller.dart';
import 'pages/discussion/discussion_controller.dart';
import 'pages/discussion/discussion_page.dart';
import 'pages/home/home_controller.dart';
import 'pages/home/discussions_page.dart';
import 'pages/home/tags_page.dart';
import 'pages/tag/tag_controller.dart';
import 'pages/tag/tag_page.dart';

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

GetPageRoute discussionsPageRoutes(settings) {
  Get.routing.args = settings.arguments;

  if (settings.name == '/') {
    return GetPageRoute(
      routeName: '/',
      settings: settings,
      page: () => DiscussionsPage()
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

GetPageRoute tagsPageRoutes(settings) {
  Get.routing.args = settings.arguments;

  if (settings.name == '/') {
    return GetPageRoute(
      routeName: '/',
      settings: settings,
      page: () => TagsPage()
    );
  }

  // Use tag for same page navigation
  if (settings.name == '/t') {
    return GetPageRoute(
      settings: settings,
      page: () => TagPage(),
      binding: BindingsBuilder(() {
        String? tag = settings.arguments is Entity ? 'tag::${settings.arguments.id}' : null;
        Get.lazyPut<TagController>(() => TagController(),
          tag: tag,
        );
      })
    );
  }

  throw 'Route not found.';
}
