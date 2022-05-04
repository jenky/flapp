import 'dart:developer';

import 'package:get/get.dart';

import '../../api/discussion_provider.dart';
import '../../models/entity.dart';

class DiscussionController extends GetxController {
  final DiscussionProvider provider = Get.find<DiscussionProvider>();
  final discussion = Entity(
    id: '0',
    type: 'discussions',
    attributes: null,
  ).obs;
  final user = Entity(
    id: '0',
    type: 'users',
    attributes: null,
  ).obs;

  final showTitle = false.obs;

  load() async {
    if (Get.arguments is Entity) {
      discussion(Get.arguments);
      user(Get.arguments.included['user']);
      var response = await provider.fetchDiscussion(Get.arguments.id);
      if (response.isOk) {
        discussion(response.body!.resource);
        // inspect(discussion.value);
      }
    }
  }

  void showOrHideTitle(bool show) {
    if (show != showTitle()) {
      showTitle(show);
    }
  }
}
