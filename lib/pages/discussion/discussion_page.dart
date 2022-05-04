import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/discussion/discussion_tags.dart';
import '../../components/floating_modal.dart';
import '../../components/html_widget_factory.dart';
import '../../models/entity.dart';
import 'discussion_controller.dart';

class DiscussionPage extends GetView<DiscussionController> {

  String? get tag => Get.arguments?.id != null ? 'discussion::${Get.arguments.id}' : null;
  final AutoScrollController scrollController = AutoScrollController(
    // viewportBoundaryGetter: () => Rect.fromLTRB(0, MediaQuery.of(context).padding.top, 0, MediaQuery.of(context).padding.bottom),
  );

  static List mapContentTypes = [
    'discussionStickied',
    'discussionLocked',
  ];

  static List listContentTypes = [
    'discussionTagged',
    'discussionRenamed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          EasyDebounce.debounce('showHideTitle', const Duration(microseconds: 100), () {
            controller.showOrHideTitle(notification.metrics.pixels > kToolbarHeight * 1.5);
          });
          return false;
        },
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              /* CupertinoSliverNavigationBar(
                // previousPageTitle: 'Discussions',
                largeTitle: Obx(() => Text(controller.discussion().attributes?.title ?? '...')),
              ), */
              SliverAppBar(
                forceElevated: innerBoxIsScrolled,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                // elevation: 0.0, // Switch to dynamic
                floating: true,
                pinned: true,
                centerTitle: false,
                titleSpacing: -30,
                title: Obx(() => AnimatedOpacity(
                  opacity: controller.showTitle() ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(controller.user().attributes?.avatarUrl ?? 'http://via.placeholder.com/150x150'),
                    ),
                    title: Text(controller.discussion().attributes?.title ?? '...',
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(controller.user().attributes?.displayName ?? '[deleted]'),
                  )),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            controller: scrollController,
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
                            Obx(() => Text(controller.discussion().attributes?.title ?? '...',
                              style: Theme.of(context).textTheme.headline5,
                            )),
                            const SizedBox(height: 6.0),
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
                        // primary: false,
                        shrinkWrap: true,
                        itemCount: controller.discussion().included['posts']?.length ?? 0,
                        itemBuilder: (context, i) {
                          Entity post = controller.discussion().included['posts'][i];

                          return AutoScrollTag(
                            controller: scrollController,
                            key: ValueKey(i),
                            index: i,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(post.included['user']?.attributes?.avatarUrl ?? 'http://via.placeholder.com/150x150'),
                                  ),
                                  title: Text(post.included['user']?.attributes.displayName ?? '[deleted]'),
                                  subtitle: Text(Jiffy(post.attributes.createdAt).fromNow()),
                                  onTap: _showUser(context, post.included['user']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _discussionContent(context, post),
                                ),
                                const SizedBox(height: 16.0),
                                _mentions(context, post),
                                _likes(context, post),
                                const SizedBox(height: 16.0),
                              ],
                            ),
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
      ),
    );
  }

  static get specialContentTypes => {...mapContentTypes, ...listContentTypes}.toList();

  Widget _discussionContent(BuildContext context, Entity post) {
    if (mapContentTypes.contains(post.attributes.contentType) && post.attributes.content != null) {
      if (post.attributes.content.containsKey('sticky')) {
        if (post.attributes.content['sticky']) {
          return Row(
            children: [
              Icon(Icons.push_pin_outlined,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Text('stickied the discussion.',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Icon(Icons.push_pin_outlined,
                color: Colors.red,
              ),
              Text('unstickied the discussion.',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          );
        }
      }

      if (post.attributes.content.containsKey('locked')) {
        if (post.attributes.content['locked']) {
          return Row(
            children: [
              Icon(Icons.lock_outline,
                color: Color(0xFF888888),
              ),
              const SizedBox(width: 10),
              Text('locked the discussion.',
                style: TextStyle(
                  color: Color(0xFF888888),
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Icon(Icons.lock_open_outlined,
                color: Colors.red,
              ),
              Text('unlocked the discussion.',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          );
        }
      }
    }

    return HtmlWidget(post.attributes.contentHtml ?? '',
      isSelectable: true,
      onTapImage: (src) => print(src),
      onTapUrl: (url) => launchUrl(Uri.parse(url)),
      factoryBuilder: () => HtmlWidgetFactory(
        onPostMentionTap: (id) {
          int to = controller.discussion().included['posts'].indexWhere((p) => p.id == id) ?? 0;
          scrollController.scrollToIndex(to,
            preferPosition: AutoScrollPosition.begin,
            duration: const Duration(seconds: 1),
          );
        },
      ),
      customStylesBuilder: (element) {
        // if (element.classes.contains('PostMention')) {
        //   return {
        //     // 'background': '#e7edf3',
        //     // 'color': '#667d99',
        //     // 'font-weight': 'bold',
        //     // 'padding': '2px',
        //     // 'text-decoration': 'none',
        //     // 'border-radius': '4px'
        //   };
        // }

        return null;
      },
      customWidgetBuilder: (element) {
        // if (element.classes.contains('PostMention') && element.attributes['data-id'] != null) {
        //   return const SizedBox.shrink();
        // }

        return null;
      },
    );
  }

  Widget _likes(BuildContext context, Entity post) {
    if (post.included.containsKey('likes') && post.included['likes'].isNotEmpty) {
      String likes = '';
      if (post.included['likes'].length > 3) {
        List sub = post.included['likes'].sublist(3);
        likes = post.included['likes'].sublist(0, 3).map((i) => i.attributes.displayName ?? '[deleted]').join(', ') + ' and ${sub.length} others like this.';
      } else {
        likes = post.included['likes'].map((i) => i.attributes.displayName ?? '[deleted]').join(', ') + ' like this.';
      }

      return GestureDetector(
        onTap: () => _showLikes(context, post.included['likes']),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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

  Widget _mentions(BuildContext context, Entity post) {
    if (post.included.containsKey('mentionedBy') && post.included['mentionedBy'].isNotEmpty) {
      String mentionedBy = '';
      if (post.included['mentionedBy'].length > 3) {
        List sub = post.included['mentionedBy'].sublist(3);
        mentionedBy = post.included['mentionedBy'].sublist(0, 3).map((i) => i.included['user']?.attributes.displayName ?? '[deleted]').join(', ') + ' and ${sub.length} others replied to this.';
      } else {
        mentionedBy = post.included['mentionedBy'].map((i) => i.included['user']?.attributes.displayName ?? '[deleted]').join(', ') + ' replied to this.';
      }

      return GestureDetector(
        onTap: () => _showMentions(context, post.included['mentionedBy']),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.reply,
                size: 14.0,
              ),
              const SizedBox(width: 5.0),
              Flexible(
                child: Text(mentionedBy,
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

  _showLikes(BuildContext context, List<Entity> likes) {
    return showBarModalBottomSheet(
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

  _showMentions(BuildContext context, List<Entity> posts) {
    return showBarModalBottomSheet(
      context: context,
      // useRootNavigator: true,
      builder: (context) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, i) {
          Entity post = posts[i];
          return ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(post.included['user']?.attributes.avatarUrl ?? 'http://via.placeholder.com/150x150'),
            ),
            title: Text(post.included['user']?.attributes.displayName ?? '[deleted]'),
            // subtitle: HtmlWidget(post.attributes.contentHtml ?? ''),
            subtitle: Text(Bidi.stripHtmlIfNeeded(post.attributes.contentHtml ?? ''),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
      ),
    );
  }

  _showUser(BuildContext context, Entity? user) {
    if (user == null) {
      return;
    }

    // showFloatingModalBottomSheet(
    //   context: context,
    //   builder: (context) => ListTile(
    //     leading: CircleAvatar(
    //       backgroundImage: CachedNetworkImageProvider(user.attributes.avatarUrl ?? 'http://via.placeholder.com/150x150'),
    //     ),
    //     title: Text(user.attributes.displayName ?? '[deleted]'),
    //   )
    // );
  }
}
