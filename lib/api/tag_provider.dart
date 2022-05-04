import 'package:get/get.dart';

import '../models/schema.dart';
import 'api_provider.dart';

class TagProvider extends ApiProvider {
  Future<Response<Schema>> fetchTags({Map<String, dynamic>? query}) {
    return get('/tags',
      query: query,
      decoder: (data) => Schema.fromRawJson(data),
    );
  }
}
