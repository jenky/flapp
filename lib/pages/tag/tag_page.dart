import 'package:badges/badges.dart';
import 'package:flarum/components/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tag_controller.dart';

class TagPage extends GetView<TagController> {

  String? get tag => Get.arguments?.id != null ? 'tag::${Get.arguments.id}' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            Obx(() => SliverAppBar(
              forceElevated: innerBoxIsScrolled,
              elevation: 0.0, // Switch to dynamic
              floating: true,
              pinned: true,
              backgroundColor: controller.tag().attributes.color != '' ? HexColor(controller.tag().attributes.color) : Theme.of(context).scaffoldBackgroundColor,
              title: Text(controller.tag().attributes.name),
              /* bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: Badge(
                  toAnimate: false,
                  borderRadius: BorderRadius.circular(4.0),
                  shape: BadgeShape.square,
                  badgeContent: Text('111'),
                )
              ), */
            )),
            /* const SliverList(delegate: SliverChildListDelegate.fixed(
              [
                TabBar(
                  labelColor: Colors.blue,
                  tabs: [
                    Tab(text: "Call"),
                    Tab(text: "Message"),
                  ],
                ),
              ]
            )), */
          ];
        },
        body: Text(controller.tag().attributes.description),
      ),
    );
  }
}
