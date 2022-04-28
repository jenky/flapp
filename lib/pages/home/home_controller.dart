import 'package:get/get.dart';

import '../has_scrollcontroller.dart';
import '../../api/tag_provider.dart';
import '../../api/discussion_provider.dart';

class HomeController extends GetxController with HasScrollController {
 final DiscussionProvider discussionProvider = Get.find<DiscussionProvider>();
}
