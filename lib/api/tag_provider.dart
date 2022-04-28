import 'dart:convert';
import 'package:get/get.dart';

import 'api_provider.dart';
import '../models/entity.dart';

class TagProvider extends ApiProvider {
  Future<Response<List<Entity>>> fetchDiscussions({Map<String, dynamic>? query}) {
    return get('/discussions',
      query: query,
      // decoder: (data) => List<Schema>.from(data['data'].map((x) => Schema.fromDiscussionsJson(x))),
      decoder: (data) {
        Map body = json.decode(data);
        return List<Entity>.from(body['data'].map((x) => Entity.fromJson(x)));
      }
    );
  }
}
