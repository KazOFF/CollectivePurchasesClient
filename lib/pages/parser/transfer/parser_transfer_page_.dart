import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';
import 'parser_transfer_page_controller.dart';

class ParserTransferPage extends GetView<ParserTransferPageController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
        title: const Text("Выгрузка товаров"),
        body: Container(padding: const EdgeInsets.all(16), child: _buildBody())));
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: Text("Закупка")),
              const SizedBox(
                width: 16,
              ),
              _buildSaleDropDown(),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Expanded(child: Text("Категория")),
              const SizedBox(
                width: 16,
              ),
              _buildCategoryDropDown(),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: controller.rateEditingController,
            decoration: _generateDecoration("Курс",
                controller.isRateValid.value, "Курс должен быть положительным числом"),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: controller.scaleEditingController,
            decoration: _generateDecoration("Коэффициент",
                controller.isScaleValid.value, "Коэффициент должен положительным быть числом"),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Expanded(child: Text("Округление")),
              const SizedBox(
                width: 16,
              ),
              _buildRoundDropDown(),
            ],
          ),
          const SizedBox(height: 16,),
          TextField(
            keyboardType: TextInputType.text,
            controller: controller.priceCommentEditingController,
            decoration: _generateDecoration("Комментарий к цене",
                true, ""),
          ),

          const SizedBox(height: 16,),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
                onPressed: (controller.isRateValid.value && controller.isScaleValid.value)
                    ? controller.transferTapped : null,
                child: const Text("Выгрузить")),
          )

        ],
      ),
    );
  }

  Widget _buildSaleDropDown() {
    return DropdownButton<SaleDTO>(
      value: controller.selectedSale.value,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (SaleDTO? value) {
        controller.selectedSale.value = value ?? SaleDTO();
      },
      items: controller.saleList
          .map<DropdownMenuItem<SaleDTO>>(
              (SaleDTO value) {
            return DropdownMenuItem<SaleDTO>(
              value: value,
              child: Text(value.name!),
            );
          }).toList(),
    );
  }

  Widget _buildCategoryDropDown() {
    return DropdownButton<SaleCategoryDTO>(
      value: controller.selectedCategory.value,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (SaleCategoryDTO? value) {
        controller.selectedCategory.value = value ?? SaleCategoryDTO();
      },
      items: controller.categoryList
          .map<DropdownMenuItem<SaleCategoryDTO>>(
              (SaleCategoryDTO value) {
            return DropdownMenuItem<SaleCategoryDTO>(
              value: value,
              child: Text(value.name!),
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


  Widget _buildRoundDropDown() {
    return DropdownButton<int>(
      value: controller.roundPlaces.value,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (int? value) {
        controller.roundPlaces.value = value ?? 0;
      },
      items: [-2,-1,0,1,2].toList()
          .map<DropdownMenuItem<int>>(
              (int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(_generateRoundLabel(value)),
            );
          }).toList(),
    );
  }

  String _generateRoundLabel(int value){
    switch(value){
      case -2: return "До ста";
      case -1: return "До десяти";
      case 1: return "До десятых";
      case 2: return "До сотых";
      default: return "До единиц";
    }
  }

}
