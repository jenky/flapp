import 'package:get/get.dart';

import 'api_provider.dart';
import '../models/user.dart';

class UserProvider extends ApiProvider {
  Future<Response<List<User>>> fetchUsers() {
    return get('/users',
      decoder: (data) => List<User>.from(data.map((x) => User.fromJson(x))),
    );
  }
}
