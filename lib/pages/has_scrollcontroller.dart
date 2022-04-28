import 'package:flutter/material.dart';

mixin HasScrollController {
  late ScrollController? scrollController;

  void scrollToTop() {
    scrollController!.animateTo(0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.linear
    );
  }
}
