import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class ParserItemViewPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var isLoading = true.obs;
  var parserItemId = int.tryParse(Get.parameters["parserItemId"] ?? "");
  var parserItem = ParserItemDTO();

  @override
  Future<void> onInit() async {
    super.onInit();
    parserItem = await apiService.getParserItem(0, parserItemId!);
    isLoading.value = false;
  }
}
