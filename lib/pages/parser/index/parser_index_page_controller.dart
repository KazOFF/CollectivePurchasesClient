import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class ParserIndexPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  final isLoading = true.obs;
  var parserCategoryList = <ParserCategoryDTO>[].obs;

  @override
  onInit() async {
    super.onInit();
    
    
    await refreshList();
  }
  
  
  Future<void> refreshList() async {
    isLoading.value = true;
    parserCategoryList.value = await apiService.getAllParserCategories();
    isLoading.value = false;
  }

  categoryItemDeleteTapped(int index) {
    Get.defaultDialog(
        confirm: ElevatedButton(
            onPressed: () async {
              await apiService.deleteParserCategory(parserCategoryList[index].id!);
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

  categoryItemTapped(int index) {
    Get.toNamed("/parser/${parserCategoryList[index].id}", arguments: parserCategoryList[index]);
  }
}
