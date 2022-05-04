import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/discussion/discussion_list_item.dart';
import '../../models/schema.dart';
import '../../models/entity.dart';
import 'home_controller.dart';

class DiscussionsPage extends GetView<HomeController> {

  @override
  Widget build(BuildContext context) {
    controller.scrollController = PrimaryScrollController.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.discussionProvider.fetchDiscussions(query: { 'include': 'user,lastPostedUser,tags' }),
        child: FutureBuilder(
          future: controller.discussionProvider.fetchDiscussions(query: { 'include': 'user,tags,lastPostedUser' }),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              } else if (snapshot.hasData) {
                List stickyDiscussions = chunk(_stickyDiscussions(snapshot.data.body), 3);
                List normalDiscussions = _normalDiscussions(snapshot.data.body);
                return DraggableHome(
                  // appBarColor: Theme.of(context).backgroundColor,
                  alwaysShowLeadingAndAction: true,
                  title: Text('Flarum'),
                  headerWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text('Sticky',
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ),
                      LimitedBox(
                        maxHeight: 240,
                        child: ListView.builder(
                          // shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          itemCount: stickyDiscussions.length,
                          itemBuilder: (context, i) => _buildStickyDiscussionList(stickyDiscussions[i]),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(CupertinoIcons.search),
                      onPressed: () {},
                    )
                  ],
                  body: [
                    ListView.separated(
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                        indent: 8.0,
                        endIndent: 8.0,
                        height: 0,
                      ),
                      padding: const EdgeInsets.only(top: 0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: normalDiscussions.length,
                      itemBuilder: (context, i) => DiscussionListItem(normalDiscussions[i]),
                    ),
                  ]
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator.adaptive()
            );
          }
        ),
      ),
    );
    // return NestedScrollView(
    //   controller: controller.scrollController,
    //   headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) => <Widget>[
    //     SliverAppBar(
    //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //       // expandedHeight: 150.0,
    //       floating: true,
    //       pinned: true,
    //       // snap: false,
    //       title: Text('Flarum'),
    //       centerTitle: false,
    //       actions: <Widget>[
    //         IconButton(
    //           onPressed: () {},
    //           splashColor: Colors.transparent,
    //           icon: const Icon(CupertinoIcons.search),
    //         ),
    //       ],
    //     ),
    //   ],
    //   body: RefreshIndicator(
    //     onRefresh: () => controller.discussionProvider.fetchDiscussions(query: { 'include': 'user,lastPostedUser,tags' }),
    //     child: FutureBuilder(
    //       future: controller.discussionProvider.fetchDiscussions(query: { 'include': 'user,tags,lastPostedUser' }),
    //       builder: (context, AsyncSnapshot snapshot) {
    //         if (snapshot.connectionState == ConnectionState.done) {
    //           if (snapshot.hasError) {
    //             return Center(
    //               child: Text(
    //                 '${snapshot.error} occurred',
    //                 style: const TextStyle(fontSize: 18),
    //               ),
    //             );
    //           } else if (snapshot.hasData) {
    //             List stickyDiscussions = chunk(_stickyDiscussions(snapshot.data.body), 3);
    //             List normalDiscussions = _normalDiscussions(snapshot.data.body);
    //             return Column(
    //               children: [
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     Padding(
    //                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //                       child: Text('Sticky',
    //                         style: Theme.of(context).textTheme.headlineSmall,
    //                       ),
    //                     ),
    //                     LimitedBox(
    //                       maxHeight: 240,
    //                       child: ListView.builder(
    //                         // shrinkWrap: true,
    //                         padding: const EdgeInsets.all(0),
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount: stickyDiscussions.length,
    //                         itemBuilder: (context, i) => _buildStickyDiscussionList(stickyDiscussions[i]),
    //                       ),
    //                     ),
    //                     // _buildStickySlides(stickyDiscussions),
    //                   ],
    //                 ),
    //                 Expanded(
    //                   child: ListView.separated(
    //                     separatorBuilder: (BuildContext context, int index) => const Divider(
    //                       indent: 8.0,
    //                       endIndent: 8.0,
    //                       height: 0,
    //                     ),
    //                     padding: const EdgeInsets.only(top: 0),
    //                     shrinkWrap: true,
    //                     physics: const NeverScrollableScrollPhysics(),
    //                     itemCount: normalDiscussions.length,
    //                     itemBuilder: (context, i) => DiscussionListItem(normalDiscussions[i]),
    //                   ),
    //                 ),
    //               ],
    //             );
    //           }
    //         }

    //         return const Center(
    //           child: CircularProgressIndicator.adaptive()
    //         );
    //       }
    //     ),
    //   ),
    //   // slivers: <Widget>[
    //     /* SliverAppBar(
    //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //       // expandedHeight: 150.0,
    //       floating: true,
    //       pinned: true,
    //       // snap: false,
    //       title: Text('Flarum'),
    //       centerTitle: false,
    //       actions: <Widget>[
    //         IconButton(
    //           onPressed: () {},
    //           splashColor: Colors.transparent,
    //           icon: const Icon(CupertinoIcons.search),
    //         ),
    //       ],
    //     ), */
    //     /* SliverToBoxAdapter(
    //       child: RefreshIndicator(
    //         onRefresh: () => controller.discussionProvider.fetchDiscussions(query: { 'include': 'user,lastPostedUser,tags' }),
    //         child: FutureBuilder(
    //           future: controller.discussionProvider.fetchDiscussions(query: { 'include': 'user,tags,lastPostedUser' }),
    //           builder: (context, AsyncSnapshot snapshot) {
    //             if (snapshot.connectionState == ConnectionState.done) {
    //               if (snapshot.hasError) {
    //                 return Center(
    //                   child: Text(
    //                     '${snapshot.error} occurred',
    //                     style: const TextStyle(fontSize: 18),
    //                   ),
    //                 );
    //               } else if (snapshot.hasData) {
    //                 List stickyDiscussions = chunk(_stickyDiscussions(snapshot.data.body), 3);
    //                 List normalDiscussions = _normalDiscussions(snapshot.data.body);
    //                 return Column(
    //                   children: [
    //                     Container(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: <Widget>[
    //                           Padding(
    //                             padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //                             child: Text('Sticky',
    //                               style: Theme.of(context).textTheme.headlineSmall,
    //                             ),
    //                           ),
    //                           LimitedBox(
    //                             maxHeight: 240,
    //                             child: ListView.builder(
    //                               shrinkWrap: true,
    //                               padding: const EdgeInsets.all(0),
    //                               scrollDirection: Axis.horizontal,
    //                               itemCount: stickyDiscussions.length,
    //                               itemBuilder: (context, i) => _buildStickyDiscussionList(stickyDiscussions[i]),
    //                             ),
    //                           ),
    //                           // _buildStickySlides(stickyDiscussions),
    //                         ],
    //                       ),
    //                     ),
    //                     ListView.separated(
    //                       separatorBuilder: (BuildContext context, int index) => const Divider(
    //                         indent: 8.0,
    //                         endIndent: 8.0,
    //                         height: 0,
    //                       ),
    //                       padding: const EdgeInsets.only(top: 0),
    //                       shrinkWrap: true,
    //                       physics: const NeverScrollableScrollPhysics(),
    //                       itemCount: normalDiscussions.length,
    //                       itemBuilder: (context, i) => DiscussionListItem(normalDiscussions[i]),
    //                     ),
    //                   ],
    //                 );
    //               }
    //             }

    //             return const Center(
    //               child: CircularProgressIndicator.adaptive()
    //             );
    //           }
    //         ),
    //       ),
    //     ),
    //   ], */
    // );
  }

  List<Entity> _normalDiscussions(Schema json) {
    return json.data.where((e) => !e.attributes.isSticky).toList();
  }

  List<Entity> _stickyDiscussions(Schema json) {
    return json.data.where((e) => e.attributes.isSticky).toList();
  }

  List chunk(List list, int chunkSize) {
    List chunks = [];
    int len = list.length;
    for (var i = 0; i < len; i += chunkSize) {
      int size = i+chunkSize;
      chunks.add(list.sublist(i, size > len ? len : size));
    }
    return chunks;
  }

  Widget _buildStickySlides(List stickyDiscussions) {
    List<Widget> slides = [];
    Widget StickySlides;

    if (stickyDiscussions.isNotEmpty) {
      for (int i = 0; i < stickyDiscussions.length; i++) {
        slides.add(_buildStickyDiscussionList(stickyDiscussions[i]));
      }

      StickySlides = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: slides),
          ),
        ],
      );
    } else {
      StickySlides = Container();
    }

    return StickySlides;
  }

  Widget _buildStickyDiscussionList(List discussions) {
    return Container(
      width: 360,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(
          indent: 70.0,
          height: 0,
        ),
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        // shrinkWrap: true,
        primary: false,
        itemCount: discussions.length,
        itemBuilder: (context, i) => DiscussionListItem(discussions[i], simple: true),
      ),
    );
    // final slides = <Widget>[];
    // Widget StickySlides;

    // if (product.length > 0) {
    //   for (int i = 0; i < product.length; i++) {
    //     cards.add(FeaturedCard(product[i]));
    //     print(product.length);
    //   }
    //   StickySlides = Container(
    //     // padding: EdgeInsets.only(top: 16, bottom: 8),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         SingleChildScrollView(
    //           scrollDirection: Axis.horizontal,
    //           child: Row(children: slides),
    //         ),
    //       ],
    //     ),
    //   );
    // } else {
    //   StickySlides = Container();
    // }
    // return StickySlides;
  }
}
