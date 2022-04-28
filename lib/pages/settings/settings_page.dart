import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_controller.dart';

class SettingsPage extends GetView {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings')
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.find<AppController>().tabController.jumpToTab(0),
          child: const Text('Go to Home'),
        )
      )
    );
  }
}
