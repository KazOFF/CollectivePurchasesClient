import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class ParserItemIndexPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var isLoading = true.obs;
  var isSelectionMode = false.obs;
  var selectedItems = <int>{}.obs;
  var parserItemList = <ParserItemDTO>[].obs;
  var parserCategoryId = int.tryParse(Get.parameters["parserCategoryId"] ?? "");
  var parserCategory = Get.arguments as ParserCategoryDTO;

  @override
  Future<void> onInit() async {
    super.onInit();
    isSelectionMode.listen(selectionModeChanged);
    await refreshList();
  }

  Future<void> refreshList()async {
    isLoading.value = true;
    parserItemList.value = await apiService.getAllParserItems(parserCategoryId!);
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
      Get.toNamed("/parser/$parserCategoryId/${parserItemList[index].id!}");
    }
  }

  selectAllTapped() {
    if(isSelectionMode.value){
      if(selectedItems.length < parserItemList.length){
        selectedItems.addAll(Iterable<int>.generate(parserItemList.length).toSet());
      }else{
        selectedItems.clear();
      }
    }
  }

  batchDeleteTapped() {
    Get.defaultDialog(
        confirm: ElevatedButton(
            onPressed: () async {
              final ids = selectedItems.map((index) => parserItemList[index].id!).toList();
              await apiService.batchDeleteParserItems(ids, parserCategoryId!);
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
    Get.toNamed("/parser/transfer", arguments: selectedItems.map((index) => parserItemList[index].id!).toList());
  }


}
