import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../../models/entity.dart';
import '../hex_color.dart';

class DiscussionTags extends StatelessWidget {
  const DiscussionTags(
    this.tags, {
    Key? key,
    this.spacing = 4.0,
    this.toAnimate = false,
    this.borderRadius = 4.0,
    this.fontSize = 10.0,
  }) : super(key: key);

  final List<Entity> tags;
  final double spacing;
  final double borderRadius;
  final double fontSize;
  final bool toAnimate;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: tags.map((t) => _tag(t, context)).toList(),
      spacing: spacing,
    );
  }

  Widget _tag(Entity tag, BuildContext context) {
    // var icon = tag.attributes.icon ? getIconFromCss(tag.attributes.icon) : '';
    return Badge(
      toAnimate: false,
      borderRadius: BorderRadius.circular(borderRadius),
      shape: BadgeShape.square,
      badgeColor: HexColor(tag.attributes.color != '' ? tag.attributes.color : '#667d99'), // #e7edf3
      badgeContent: Text(tag.attributes.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
