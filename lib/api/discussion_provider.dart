import 'package:get/get.dart';

import 'api_provider.dart';
import '../models/schema.dart';

class DiscussionProvider extends ApiProvider {
  Future<Response<Schema>> fetchDiscussions({Map<String, dynamic>? query}) {
    return get('/discussions',
      query: query,
      decoder: (data) => Schema.fromRawJson(data),
    );
  }

  Future<Response<Schema>> fetchDiscussion(dynamic id) {
    return get('/discussions/${id}',
      query: { 'page[near]': '0' },
      decoder: (data) => Schema.fromRawJson(data),
    );
  }
}
