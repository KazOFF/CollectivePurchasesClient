import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

import 'sale_edit_page_controller.dart';

class SaleEditPage extends GetView<SaleEditPageController> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: controller.saleId == null ? const Text("Новая закупка") : Text("Редактирование"),
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.datetime,
                  controller: controller.datesEditingController,
                  readOnly: true,
                  decoration: _generateDecoration("Даты закупки", true, ""),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                  onPressed: () => controller.starDateButtonTapped(),
                  child: const Text("Выбрать"))
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Expanded(child: Text("Страна закупки")),
              const SizedBox(
                width: 16,
              ),
              _buildDropDown(),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Expanded(child: Text("Активная закупка")),
              const SizedBox(
                width: 16,
              ),
              Switch(
                value: controller.isActive.value,
                //overlayColor: overlayColor,
               // trackColor: trackColor,
                thumbColor: MaterialStatePropertyAll<Color>(Get.theme.colorScheme.primary),
                onChanged: (bool value) {
                  controller.isActive.value = value;
                },
              )
            ],
          ),
          const SizedBox(height: 16,),
          Row(
            children: [
              Expanded(child:
                Text("Изображение",
                style: TextStyle(
                  color: controller.isFileChosen.value ? Colors.green : Colors.red,
                ),),),
              const SizedBox(width: 16,),
              ElevatedButton(onPressed: controller.pictureButtonTapped, child: const Text("Выбрать изображение")),
            ],
          ),
          const SizedBox(height: 16,),
          SizedBox(width: double.infinity,
            child: ElevatedButton(onPressed: controller.saveSale, child: const Text("Сохранить")),
            )

        ],
      ),
    );
  }

  Widget _buildDropDown() {
    return DropdownButton<SaleDTOCountryEnum>(
      value: controller.saleCountry.value,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (SaleDTOCountryEnum? value) {
        controller.saleCountry.value = value ?? SaleDTOCountryEnum.RUS;
      },
      items: SaleDTOCountryEnum.values
          .map<DropdownMenuItem<SaleDTOCountryEnum>>(
              (SaleDTOCountryEnum value) {
        return DropdownMenuItem<SaleDTOCountryEnum>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
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
