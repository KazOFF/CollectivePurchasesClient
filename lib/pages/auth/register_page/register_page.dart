import 'package:collective_purchases_client/pages/auth/login_page/login_page_controller.dart';
import 'package:collective_purchases_client/pages/auth/register_page/register_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends GetView<RegisterPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 32,
            ),
            Obx(() => TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailEditingController,
                  decoration: _generateDecoration(
                      "Email",
                      controller.isEmailValid.value,
                      "Введите корректный email"),
                )),
            const SizedBox(
              height: 32,
            ),
            Obx(() => TextField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: controller.passwordEditingController,
                  decoration: _generateDecoration(
                      "Пароль",
                      controller.isPasswordValid.value,
                      "Пароль должен быть не короче 3 символов"),
                )),
            const SizedBox(
              height: 32,
            ),
            Obx(() => TextField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              controller: controller.passwordSecondEditingController,
              decoration: _generateDecoration(
                  "Повторите пароль",
                  controller.isSecondPasswordValid.value,
                  "Введенные пароли должны совпадать"),
            )),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 50,
              child: Obx(() => ElevatedButton(
                  onPressed: controller.isButtonEnabled.value ? () => controller.registerButtonPressed() : null,
                  child: const Text("Зарегистрироваться")),
            )),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                  onPressed: () => controller.loginButtonPressed(),
                  child: const Text("Вход")),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _generateDecoration(
      String hintText, bool isValid, String invalidText) {
    return InputDecoration(
        hintText: hintText,
        errorText: isValid ? null : invalidText,
        border: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Get.theme.colorScheme.primary)));
  }
}
