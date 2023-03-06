import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
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

  loginButtonPressed(){

  }

  registerButtonPressed(){
    Get.offNamed("/auth/register");
  }

}
