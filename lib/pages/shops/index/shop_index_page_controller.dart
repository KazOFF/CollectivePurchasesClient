import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class ShopIndexPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var isLoading = true.obs;
  var shopList = <ParserShopDTO>[].obs;

  @override
  void onInit() {
    super.onInit();

    refreshList();
  }


  void newShopItemTapped() {
    Get.toNamed("/shops/new");
  }

  Future<void> refreshList() async {
    isLoading.value = true;
    shopList.value = await apiService.getAllShops();
    shopList.sort((a,b) => a.name!.compareTo(b.name!));
    isLoading.value = false;
  }

  shopItemDeleteTapped(int index) {
    Get.defaultDialog(
        confirm: ElevatedButton(
            onPressed: () async {
              await apiService.deleteShop(shopList[index].id!);
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
        middleText: "Вы уверены что хотите удалить этот сайт?"
    );
  }

  shopItemEditTapped(int index) {
    Get.toNamed("/shops/${shopList[index].id}/edit");
  }

  shopItemTapped(int index) {}
}
