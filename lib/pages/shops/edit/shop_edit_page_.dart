import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shop_edit_page_controller.dart';

class ShopEditPage extends GetView<ShopEditPageController> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: controller.shopId == null
            ? const Text("Новый сайт")
            : const Text("Редактирование"),
        body: Obx(() =>
            Container(padding: const EdgeInsets.all(16), child: _buildBody())));
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            keyboardType: TextInputType.name,
            controller: controller.nameEditingController,
            decoration: _generateDecoration("Название",
                controller.isNameValid.value, "Название не должно быть пустым"),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: TextInputType.name,
            controller: controller.baseUrlEditingController,
            decoration: _generateDecoration(
                "Базовый URL",
                controller.isBaseUrlValid.value,
                "Ссылка не должна быть пустой"),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Изображение",
                  style: TextStyle(
                    color: controller.isFileChosen.value
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                  onPressed: controller.pictureButtonTapped,
                  child: const Text("Выбрать изображение")),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Expanded(child: Text("Нажна ли аутентификация")),
              const SizedBox(
                width: 16,
              ),
              Switch(
                value: controller.isNeedLogin.value,
                thumbColor: MaterialStatePropertyAll<Color>(
                    Get.theme.colorScheme.primary),
                onChanged: (bool value) {
                  controller.isNeedLogin.value = value;
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          controller.isNeedLogin.value
              ? TextField(
                  keyboardType: TextInputType.name,
                  controller: controller.loginEditingController,
                  decoration: _generateDecoration("Логин", true, ""),
                )
              : const SizedBox.shrink(),
          controller.isNeedLogin.value
              ? const SizedBox(
                  height: 16,
                )
              : const SizedBox.shrink(),
          controller.isNeedLogin.value
              ? TextField(
                  keyboardType: TextInputType.name,
                  controller: controller.passwordEditingController,
                  decoration: _generateDecoration("Пароль", true, ""),
                )
              : const SizedBox.shrink(),
          controller.isNeedLogin.value
              ? const SizedBox(
                  height: 16,
                )
              : const SizedBox.shrink(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: controller.saveButtonPressed,
                child: const Text("Сохранить")),
          ),
        ],
      ),
    );
  }

  InputDecoration _generateDecoration(
      String hintText, bool isValid, String invalidText) {
    return InputDecoration(
        labelText: hintText,
        errorText: isValid ? null : invalidText,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Get.theme.colorScheme.primary)));
  }
}
