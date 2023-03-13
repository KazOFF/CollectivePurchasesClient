import 'dart:io';

import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:get/get.dart';


class LogoutPageController extends GetxController {
  var apiService = Get.find<ApiService>();

  @override
  void onInit() {

    apiService.logout();
    //sleep(const Duration(seconds: 3));
    Get.offAllNamed("/auth/login");
    super.onInit();
  }
}
