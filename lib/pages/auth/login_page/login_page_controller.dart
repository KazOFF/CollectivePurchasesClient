import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  var isEmailValid = true.obs;
  var isPasswordValid = true.obs;
  var isButtonEnabled = false.obs;


  @override
  void onInit() {
    emailEditingController.addListener(_validateEmail);
    passwordEditingController.addListener(_validatePassword);
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

  _validateButton(){
    isButtonEnabled.value = isEmailValid.value && isPasswordValid.value;
  }

  loginButtonPressed() async {
      if(await apiService.login(
          email: emailEditingController.text.trim(),
          password: passwordEditingController.text.trim())) {
        Get.offAllNamed("/dashboard");
      }
    // }on ApiException catch(ex){
    //   Get.snackbar(
    //     "Ошибка",
    //     ex.message!,
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //   );
    // }

  }

  registerButtonPressed(){
    Get.offNamed("/auth/register");
  }

}
