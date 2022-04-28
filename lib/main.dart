import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart' as route;

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flarum',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // backgroundColor: const Color(0XFFE7EDF3),
      ),
      // unknownRoute: GetPage(name: '/notfound', page: () => UnknownRoutePage()),
      // initialRoute: '/',
      getPages: route.pages
    );
  }
}
