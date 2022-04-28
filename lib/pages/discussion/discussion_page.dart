import 'package:cached_network_image/cached_network_image.dart';
import 'package:flarum/components/discussion/discussion_tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:sliver_header_delegate/sliver_header_delegate.dart';

import '../../models/entity.dart';
import 'discussion_controller.dart';

class DiscussionPage extends GetView<DiscussionController> {

  String? get tag => Get.arguments?.id != null ? 'discussion::${Get.arguments.id}' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            /* SliverPersistentHeader(
              pinned: true,
              delegate: FlexibleHeaderDelegate(
                statusBarHeight: MediaQuery.of(context).padding.top,
                expandedHeight: kToolbarHeight * 2,
                children: <Widget>[
                  FlexibleTextItem(
                    text: controller.discussion().attributes?.title ?? '...',
                    collapsedStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                    expandedStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    expandedAlignment: Alignment.bottomLeft,
                    expandedPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  ),
                ],
              )
            ), */
            CupertinoSliverNavigationBar(
              // previousPageTitle: 'Discussions',
              largeTitle: Obx(() => Text(controller.discussion().attributes?.title ?? '...')),
            ),
            /* SliverAppBar(
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              // elevation: 0.0,
              expandedHeight: 200.0, // Switch to dynamic
              floating: true,
              pinned: true,
              // title: Text('12'),
              flexibleSpace: CustomizableSpaceBar(
                builder: (BuildContext context, scrollingRate) {
                  // var top = constraints.biggest.height;
                  // return FlexibleSpaceBar(
                  //   // collapseMode: CollapseMode.none,
                  //   title: AnimatedOpacity(
                  //     duration: Duration(milliseconds: 300),
                  //     opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 0 : 1,
                  //     child: Obx(() => Text(controller.discussion().attributes?.title ?? '...'))
                  //   ),
                  // );
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 12 + 40 * scrollingRate),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(controller.discussion().attributes?.title ?? '...',
                        style: TextStyle(
                          fontSize: 42 - 18 * scrollingRate,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  );
                },
              ),
            ), */
          ];
        },
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: controller.load(),
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /* Obx(() => Text(controller.discussion().attributes?.title ?? '...',
                            style: Theme.of(context).textTheme.headline5,
                          )),
                          const SizedBox(height: 6.0), */
                          Obx(() => DiscussionTags(controller.discussion().included['tags'],
                            fontSize: 12,
                          )),
                        ],
                      ),
                    ),
                    ListView.separated(
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                        // indent: 8.0,
                        // endIndent: 8.0,
                        height: 0,
                      ),
                      padding: const EdgeInsets.only(top: 0, bottom: 16.0),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: controller.discussion().included['posts']?.length ?? 0,
                      itemBuilder: (context, i) {
                        Entity post = controller.discussion().included['posts'][i];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(post.included['user']?.attributes?.avatarUrl ?? 'http://via.placeholder.com/150x150'),
                              ),
                              title: Text(post.included['user']?.attributes.displayName ?? '[deleted]'),
                              subtitle: Text(Jiffy(post.attributes.createdAt).fromNow()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: HtmlWidget(post.attributes.contentHtml ?? '',
                                isSelectable: true,
                                onTapImage: (src) => print(src),
                                onTapUrl: (url) => true,
                              ),
                            ),
                            _likes(context, post),
                          ],
                        );
                      },
                    ),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator.adaptive()
              );
            },
          ),
        )
      ),
    );
  }

  Widget _likes(BuildContext context, Entity post) {
    if (post.included.containsKey('likes') && post.included['likes'].isNotEmpty) {
      String likes = '';
      if (post.included['likes'].length > 3) {
        List sub = post.included['likes'].sublist(3);
        likes = post.included['likes'].sublist(0, 3).map((i) => i.attributes.displayName).join(', ') + ' and ${sub.length} others like this';
      } else {
        likes = post.included['likes'].map((i) => i.attributes.displayName).join(', ') + ' like this';
      }

      return GestureDetector(
        onTap: () => _showLikes(context, post.included['likes']),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.thumb_up_alt_outlined,
                size: 14.0,
              ),
              const SizedBox(width: 5.0),
              Flexible(
                child: Text(likes,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }

  void _showLikes(BuildContext context, List<Entity> likes) {
    showBarModalBottomSheet(
      context: context,
      // useRootNavigator: true,
      builder: (context) => ListView.builder(
        itemCount: likes.length,
        itemBuilder: (context, i) {
          Entity user = likes[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.attributes?.avatarUrl ?? 'http://via.placeholder.com/150x150'),
            ),
            title: Text(user.attributes?.displayName),
          );
        }
      ),
    );
  }
}
