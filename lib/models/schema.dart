import 'dart:convert';
import 'dart:developer';

import 'entity.dart';
import 'links.dart';

class Schema {
  Schema({
    this.links,
    required this.data,
    this.included
  });

  Links? links;
  List<Entity> data;
  // dynamic data;
  List<Entity>? included;

  Entity get resource => data.first;

  factory Schema.fromRawJson(String str) => Schema.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Schema.fromJson(Map<String, dynamic> json) {
    List<Entity> included = json.containsKey('included') ? List<Entity>.from(json['included'].map((x) => Entity.fromJson(x))) : [];
    List<Entity> resources = [];

    if (json['data'] is Map) {
      resources.add(Entity.fromJson(json['data']).loadIncluded(included));
    } else {
      resources = List<Entity>.from(json['data'].map((x) => Entity.fromJson(x).loadIncluded(included)));
    }

    return Schema(
      links: json.containsKey('links') ? Links.fromJson(json['links']) : null,
      data: resources,
      included: included,
    );
  }

  Map<String, dynamic> toJson() => {
    'links': links?.toJson(),
    'data': List<Entity>.from(data.map((x) => x)),
    'included': included != null ? List<dynamic>.from(included!.map((x) => x)) : null,
  };
}
