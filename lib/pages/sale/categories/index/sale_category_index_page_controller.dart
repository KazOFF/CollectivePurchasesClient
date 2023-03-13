import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class SaleCategoryIndexPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var categoryNameEditingController = TextEditingController();
  var saleCategoryList = <SaleCategoryDTO>[].obs;
  var isLoading = true.obs;
  var categoryNameIsValid = false.obs;
  var saleId = int.parse(Get.parameters["saleId"]!);
  var sale = Get.arguments as SaleDTO;

  @override
  Future<void> onInit() async {
    await refreshList();
    categoryNameEditingController.addListener(() => categoryNameIsValid.value =
        categoryNameEditingController.text.isNotEmpty);

    super.onInit();
  }

  Future<void> refreshList() async {
    isLoading.value = true;
    saleCategoryList.value = await apiService.getAllSaleCategories(saleId);
    saleCategoryList.sort((a, b) => a.name!.compareTo(b.name!));
    isLoading.value = false;
  }

  categoryItemTapped(int index) {
    Get.toNamed("/sale/$saleId/${saleCategoryList[index].id}", arguments: saleCategoryList[index]);
  }

  categoryItemNewTapped() {
    categoryNameEditingController.text = "";
    _buildDialog(-1);
  }

  categoryItemEditTapped(int index) {
    categoryNameEditingController.text = saleCategoryList[index].name!;
    _buildDialog(index);
  }

  categoryItemDeleteTapped(int index) {
    Get.defaultDialog(
        confirm: ElevatedButton(
            onPressed: () async {
              await apiService.deleteSaleCategory(
                  saleId, saleCategoryList[index].id!);
              refreshList();
              Get.back();
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
            ),
            child: const Text("Удалить")),
        cancel: OutlinedButton(
            onPressed: () => Get.back(), child: const Text("Закрыть")),
        title: "",
        middleText: "Вы уверены что хотите удалить эту категорию?"
    );
  }

  void dialogSaveNewButtonTapped() async {
    await apiService.createSaleCategory(
        saleId, categoryNameEditingController.text.trim());
    refreshList();
    Get.back();
  }

  void dialogSaveButtonTapped(int index) async {
    await apiService.updateSaleCategory(saleId, saleCategoryList[index].id!,
        categoryNameEditingController.text.trim());
    refreshList();
    Get.back();
  }

  _buildDialog(int index) {
    Get.defaultDialog(
        title: index == -1 ? "Новая категория" : "Редактировать",
        content: Obx(() => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: "Название",
                        errorText: categoryNameIsValid.value
                            ? null
                            : "Название не может быть пустым",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.colorScheme.primary))),
                    controller: categoryNameEditingController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (categoryNameIsValid.value) {
                              if (index == -1) {
                                dialogSaveNewButtonTapped();
                              } else {
                                dialogSaveButtonTapped(index);
                              }
                            }
                          },
                          child: const Text("Сохранить")),
                      //Expanded(child: SizedBox.shrink()),
                      OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text("Закрыть"))
                    ],
                  ),
                ],
              ),
            )));
  }
}
