import 'dart:io';

import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class DashboardPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  final Logger logger = Logger();
  var isLock = true.obs;
  var isLoading = true.obs;
  



  @override
  Future<void> onInit() async {
    super.onInit();
  }

}