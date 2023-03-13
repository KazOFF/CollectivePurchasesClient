import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final passwordSecondEditingController = TextEditingController();

  var isEmailValid = true.obs;
  var isPasswordValid = true.obs;
  var isSecondPasswordValid = true.obs;
  var isButtonEnabled = false.obs;

  @override
  void onInit() {
    emailEditingController.addListener(_validateEmail);
    passwordEditingController.addListener(_validatePassword);
    passwordEditingController.addListener(_validatePasswordSecond);
    passwordSecondEditingController.addListener(_validatePasswordSecond);

    super.onInit();
  }

  _validateEmail(){
    isEmailValid.value = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailEditingController.text);
    _validateButton();
  }

  _validatePassword(){
    isPasswordValid.value = passwordEditingController.text.length >= 3;
    _validateButton();
  }

  _validatePasswordSecond(){
    isSecondPasswordValid.value = passwordEditingController.text == passwordSecondEditingController.text;
    _validateButton();
  }

  _validateButton(){
    isButtonEnabled.value = isEmailValid.value && isPasswordValid.value && isSecondPasswordValid.value;
  }

  loginButtonPressed(){
    Get.offNamed("/auth/login");
  }

  registerButtonPressed() async {
    // try {
    //   final response = await apiService.register(
    //       email: emailEditingController.text.trim(),
    //       password: passwordEditingController.text.trim());
    //
    //   apiService.authToken = response.token;
    //   Get.offAllNamed("/dashboard");
    // }on ApiException catch(ex){
    //   Get.snackbar(
    //     "Ошибка",
    //     ex.message!,
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //   );
    // }
  }

}
