import 'package:flarum/components/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/entity.dart';
import '../home/home_controller.dart';

class TagsPage extends GetView<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Tags'),
            ),
          ];
        },
        body: FutureBuilder(
          future: controller.tagProvider.fetchTags(query: { 'include': 'children,lastPostedDiscussion,parent' }),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }

              List<Entity> tags = snapshot.data.body.data;
              List<Entity> filteredTags = tags.where((t) => !t.attributes.isChild && !t.attributes.isHidden).toList();

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: filteredTags.length,
                itemBuilder: (context, i) {
                  Entity tag = filteredTags[i];
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: HexColor(tag.attributes.color != '' ? tag.attributes.color : '#e7edf3'),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(tag.attributes.name,
                          style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: tag.attributes.color != '' ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(tag.attributes.description,
                          style: TextStyle(
                            color: tag.attributes.color != '' ? Colors.white : Colors.black,
                          )
                        ),
                      ],
                    ),
                  );
                }
              );
            }

            return const Center(
              child: CircularProgressIndicator.adaptive()
            );
          },
        ),
      ),
    );
  }
}
