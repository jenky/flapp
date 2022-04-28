import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AppController extends GetxController {
  final PersistentTabController _tabController = PersistentTabController(initialIndex: 0);

  PersistentTabController get tabController => _tabController;
}
