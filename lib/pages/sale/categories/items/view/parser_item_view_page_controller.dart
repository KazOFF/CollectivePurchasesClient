import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class SaleItemViewPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var isLoading = true.obs;
  var saleId = int.tryParse(Get.parameters["saleId"] ?? "");
  var saleCategoryId = int.tryParse(Get.parameters["saleCategoryId"] ?? "");
  var saleItemId = int.tryParse(Get.parameters["saleItemId"] ?? "");
  var saleItem = SaleItemDTO();

  @override
  Future<void> onInit() async {
    super.onInit();
    saleItem = await apiService.getSaleItem(saleId!, saleCategoryId!, saleItemId!);
    isLoading.value = false;
  }
}
