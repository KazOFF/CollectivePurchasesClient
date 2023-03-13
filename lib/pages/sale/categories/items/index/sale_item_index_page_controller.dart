import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class SaletemIndexPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var isLoading = true.obs;
  var isSelectionMode = false.obs;
  var selectedItems = <int>{}.obs;
  var saleItemList = <SaleItemDTO>[].obs;
  var saleCategoryId = int.tryParse(Get.parameters["saleCategoryId"] ?? "");
  var saleCategory = Get.arguments as SaleCategoryDTO;

  @override
  Future<void> onInit() async {
    super.onInit();
    isSelectionMode.listen(selectionModeChanged);
    await refreshList();
  }

  Future<void> refreshList()async {
    isLoading.value = true;
    saleItemList.value = await apiService.getAllSaleItems(saleCategoryId!);
    selectedItems.clear();
    isLoading.value = false;
  }

  void selectionModeChanged(bool active){
    if(!active){
      selectedItems.clear();
    }
  }

  bool isSelected(int index){
    return isSelectionMode.value && selectedItems.contains(index);
  }

  parserItemTapped(int index) {
    if(isSelectionMode.value){
      if(isSelected(index)){
        selectedItems.remove(index);
      }else{
        selectedItems.add(index);
      }
    }else{
      Get.toNamed("/sale/${Get.parameters["saleId"]}/$saleCategoryId/${saleItemList[index].id!}");
    }
  }

  selectAllTapped() {
    if(isSelectionMode.value){
      if(selectedItems.length < saleItemList.length){
        selectedItems.addAll(Iterable<int>.generate(saleItemList.length).toSet());
      }else{
        selectedItems.clear();
      }
    }
  }

  batchDeleteTapped() {
    Get.defaultDialog(
        confirm: ElevatedButton(
            onPressed: () async {
              final ids = selectedItems.map((index) => saleItemList[index].id!).toList();
              await apiService.batchDeleteSaleItems(ids);
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
        middleText: "Вы уверены что хотите удалить выбранные товары?"
    );
  }

  batchTransferTapped() {
    Get.toNamed("/parser/transfer", arguments: selectedItems.map((index) => saleItemList[index].id!).toList());
  }


}
