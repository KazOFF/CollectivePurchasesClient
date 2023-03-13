import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class SaleIndexPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var isLoading = true.obs;
  RxList<SaleDTO> saleList = RxList<SaleDTO>();


  @override
  Future<void> onInit() async {
    refreshList();
    super.onInit();
  }



  sortList(SortType type) {
    switch (type) {
      case SortType.name:
        saleList.sort((a, b) => a.name!.compareTo(b.name!));
        break;
      case SortType.startDate:
        saleList.sort((a, b) => a.startDate!.compareTo(b.startDate!));
        break;
      case SortType.endDate:
        saleList.sort((a, b) => a.endDate!.compareTo(b.endDate!));
    }
  }

  newSaleItemTapped() async {
    final result = await Get.toNamed("/sale/new");
  }

  saleItemTapped(int index) {
    final item = saleList[index];
    Get.toNamed("/sale/${item.id}", arguments: item);
  }

  Future<void> refreshList() async {
    isLoading.value = true;
    saleList.value = await apiService.getAllSales();
    isLoading.value = false;
  }

  categoryItemDeleteTapped(int index) {
    Get.defaultDialog(
        confirm: ElevatedButton(
            onPressed: () async {
              await apiService.deleteSale(saleList[index].id!);
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
        middleText: "Вы уверены что хотите удалить эту закупку?"
    );
  }

  categoryItemEditTapped(int index) {
    Get.toNamed("/sale/${saleList[index].id}/edit");
  }
}

enum SortType { name, startDate, endDate }
