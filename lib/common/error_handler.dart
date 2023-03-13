import 'package:collective_purchases_client/common/cp_server_exceptions.dart';
import 'package:flutter/src/foundation/assertions.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GlobalErrorHandler {
  void onErrorDetails(FlutterErrorDetails details) {}

  bool onError(Object error, StackTrace stack) {
    if (error is AuthenticationException) {
      Get.snackbar("Ошибка", error.message,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5));
      Get.offAllNamed("/auth/login");
    } else if (error is NotAuthenticatedException) {
      Get.snackbar("Ошибка", error.message,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5));
      Get.offAllNamed("/auth/login");
    } else if (error is CPServerException) {
      Get.snackbar("Ошибка", error.message,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5));
    }else{
      return false;
    }
    return true;
  }
}
