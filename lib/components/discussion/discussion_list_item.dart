import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../../models/discussion.dart';
import '../../models/entity.dart';
import '../../models/user.dart';
import 'discussion_tags.dart';

class DiscussionListItem extends StatelessWidget {
  const DiscussionListItem(
    this.entity, {
      Key? key,
      this.simple = false,
    }
  ) : super(key: key);

  final Entity entity;
  final bool simple;

  @override
  Widget build(BuildContext context) {
    Discussion discussion = entity.attributes;
    User? user = entity.included['user']?.attributes;
    User? lastPostedUser = entity.included['lastPostedUser']?.attributes;
    return Container(
      // color: Colors.white,
      child: GestureDetector(
        onTap: () => Get.toNamed('/d', arguments: entity, id: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user?.avatarUrl ?? 'http://via.placeholder.com/150x150'),
              ),
              title: Text(discussion.title,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('${user?.displayName} · ${Jiffy(discussion.createdAt).fromNow()}'),
              /* trailing: IconButton(
                icon: const Icon(CupertinoIcons.share),
                onPressed: () {},
              ), */
              trailing: DiscussionTags(entity.included.containsKey('tags') ? entity.included['tags'] : []),
            ),
            Visibility(
              visible: !simple,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // DiscussionTags(entity.included.containsKey('tags') ? entity.included['tags'] : []),
                    // const SizedBox(height: 8.0),
                    Visibility(
                      visible: discussion.commentCount > 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              const Icon(CupertinoIcons.reply,
                                size: 14.0,
                              ),
                              Text(' ${lastPostedUser?.displayName} replied ${Jiffy(discussion.lastPostedAt).fromNow()}'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(CupertinoIcons.chat_bubble,
                                size: 14.0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(NumberFormat.compact().format(discussion.commentCount)),
                            ],
                          ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: <Widget>[
                          //     Html(
                          //       data: firstPost.contentHtml,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
