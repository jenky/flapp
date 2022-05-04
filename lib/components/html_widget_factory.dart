import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlWidgetFactory extends WidgetFactory {
  HtmlWidgetFactory({
    this.onPostMentionTap,
    this.onUserMentionTap,
  }) : super();

  // final GestureTapCallback(String )? onMentionTap;
  final void Function(String?)? onPostMentionTap;
  final void Function(String?)? onUserMentionTap;

  @override
  void parse(BuildMetadata meta) {
    final e = meta.element;

    if (e.localName == 'a') {
      if (e.classes.contains('PostMention') && e.attributes['data-id'] != null) {
        meta.register(BuildOp(
          onTree: (_, tree) {
            final widget = InkWell(
              onTap: () => onPostMentionTap != null ? onPostMentionTap!(e.attributes['data-id']) : null,
              child: Badge(
                badgeColor: const Color(0XFFE7EDF3),
                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                badgeContent: Wrap(
                  children: [
                    const Icon(Icons.reply,
                      size: 16,
                    ),
                    Text(e.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
                shape: BadgeShape.square,
              ),
            );

            WidgetBit.inline(tree.parent!, widget,
              alignment: PlaceholderAlignment.middle,
            ).insertBefore(tree);

            tree.detach();
          },
        ));
      }

      if (e.classes.contains('UserMention')) {
        meta.register(BuildOp(
          onTree: (_, tree) {
            final widget = InkWell(
              onTap: () => onUserMentionTap != null ? onUserMentionTap!(e.text) : null,
              child: Badge(
                badgeColor: const Color(0XFFE7EDF3),
                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                badgeContent: Text(e.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  )
                ),
                borderRadius: BorderRadius.circular(4),
                shape: BadgeShape.square,
              ),
            );

            WidgetBit.inline(tree.parent!, widget,
              alignment: PlaceholderAlignment.middle,
            ).insertBefore(tree);

            tree.detach();
          },
        ));
      }
    }

    return super.parse(meta);
  }
}
