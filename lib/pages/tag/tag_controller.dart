import 'dart:developer';

import 'package:get/get.dart';

import '../../api/tag_provider.dart';
import '../../models/entity.dart';

class TagController extends GetxController {
 final TagProvider provider = Get.find<TagProvider>();
 final tag = Entity(
    id: '0',
    type: 'tags',
    attributes: null,
  ).obs;

  @override
  onInit() {
    if (Get.arguments is Entity) {
      tag(Get.arguments);
      inspect(tag());
    }
    super.onInit();
  }
}
