import 'package:get/get.dart';

abstract class ApiProvider extends GetConnect {

  @override
  onInit() {
    httpClient.baseUrl = 'https://discuss.flarum.org/api';

    httpClient.addRequestModifier<void>((request) async {
      request.headers['Accept'] = 'application/json';
      return request;
    });
  }
}
