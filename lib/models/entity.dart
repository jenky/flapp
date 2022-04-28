import 'dart:convert';

import 'package:collection/collection.dart';

import 'discussion.dart';
import 'post.dart';
import 'tag.dart';
import 'user.dart';

class Entity {
  Entity({
    required this.id,
    required this.type,
    required this.attributes,
    this.relationships,
  });

  String id;
  String type;
  dynamic attributes;
  Map? relationships;
  Map<String, dynamic> included = {};

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
    type: json['type'],
    id: json['id'],
    attributes: createModelFromAttribute(json['type'], json['attributes']),
    relationships: json['relationships'],
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'attributes': attributes.toJson(),
    'relationships': json.encode(relationships),
  };

  Entity loadIncluded(List<Entity> data) {
    if (relationships == null) {
      return this;
    }

    relationships!.forEach((key, value) {
      if (value['data'] is Map) {
        var item = data.firstWhereOrNull((e) => e.type == value['data']['type'] && e.id == value['data']['id']);
        if (item is Entity) {
          included[key] = item.loadIncluded(data);
        }
      } else {
        if (value['data'].isNotEmpty) {
          List ids = value['data'].map((e) => e['id']).toList();
          String type = value['data'].first['type'];

          var items = data.where((e) => e.type == type && ids.contains(e.id)).map((x) => x.loadIncluded(data)).toList();
          // var items = data.where((e) => e.type == type && ids.contains(e.id)).toList();

          if (items.isNotEmpty) {
            included[key] = items;
          }
        }
      }
    });

    // if (relationships!.containsKey('user')) {
    //   Entity user = data.where((e) => e.type == 'users' && e.id == relationships?['user']['data']['id']).first;
    //   included['user'] = user;
    // }

    // if (relationships!.containsKey('lastPostedUser')) {
    //   Entity user = data.where((e) => e.type == 'users' && e.id == relationships?['lastPostedUser']['data']['id']).first;
    //   included['lastPostedUser'] = user;
    // }

    // if (relationships!.containsKey('posts')) {
    //   // Entity user = data.where((e) => e.type == 'users' && e.id == relationships?['lastPostedUser']['data']['id']).first;
    //   List ids = relationships?['posts']['data'].map((e) => e['id']).toList();
    //   included['posts'] = data.where((e) => e.type == 'posts' && ids.contains(e.id)).map((x) => x.loadIncluded(data)).toList();
    // }

    return this;
  }

  static createModelFromAttribute(String type, Map<String, dynamic> attributes) {
    switch (type) {
      case 'discussions':
        return Discussion.fromJson(attributes);

      case 'posts':
        return Post.fromJson(attributes);

      case 'users':
        return User.fromJson(attributes);

      case 'tags':
        return Tag.fromJson(attributes);

      default:
        return attributes;
    }
  }
}
