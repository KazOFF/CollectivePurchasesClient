import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class JobIndexPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var isLoading = true.obs;
  var jobList = <ParserJobDTO>[].obs;
  var urlEditingController = TextEditingController();
  var shop = ParserShopDTO().obs;

  @override
  void onInit() {
    super.onInit();
    refreshList();
  }

  Future<void> refreshList() async {
    isLoading.value = true;
    jobList.value = await apiService.getAllJobs();
    isLoading.value = false;
  }

  jobItemNewTapped() {
    urlEditingController.text = "";
    _buildDialog();
  }

  jobItemDeleteTapped(int index) {
    Get.defaultDialog(
        confirm: ElevatedButton(
            onPressed: () async {
              await apiService.deleteJob(jobList[index].id!);
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
        middleText: "Вы уверены что хотите удалить эту задачу?"
    );
  }

  jobItemRefreshTapped(int index) {
    Get.defaultDialog(
        confirm: ElevatedButton(
            onPressed: () async {
              await apiService.refreshJob(jobList[index].id!);
              refreshList();
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Get.theme.colorScheme.primary),
            ),
            child: const Text("Перезапустить")),
        cancel: OutlinedButton(
            onPressed: () => Get.back(), child: const Text("Закрыть")),
        title: "",
        middleText: "Вы уверены что хотите перезапустить эту задачу?"
    );
  }


  void dialogSaveButtonTapped() async {
    await apiService.createJob(urlEditingController.text, shop.value.id!);
    refreshList();
    Get.back();
  }

  _buildDialog() async {
    final shopList = (await apiService.getAllShops()).obs;
    shop.value = shopList.first;
    shopList.sort((a, b) => a.name!.compareTo(b.name!));
    Get.defaultDialog(
        title: "Новая задача",
        content: Obx(() => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: "URL",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.colorScheme.primary))),
                    controller: urlEditingController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Text("Сайт:"),
                      const Spacer(),
                      DropdownButton<ParserShopDTO>(
                        value: shop.value,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        onChanged: (ParserShopDTO? value) {
                          shop.value = value!;
                        },
                        items: shopList.map<DropdownMenuItem<ParserShopDTO>>(
                            (ParserShopDTO value) {
                          return DropdownMenuItem<ParserShopDTO>(
                            value: value,
                            child: Text(value.name ?? ""),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () => dialogSaveButtonTapped(),
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
