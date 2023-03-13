import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

class ParserTransferPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var isLoading = true.obs;
  final List<int> ids = Get.arguments;

  var saleList = <SaleDTO>[].obs;
  var categoryList = <SaleCategoryDTO>[].obs;
  var selectedSale = SaleDTO().obs;
  var selectedCategory = SaleCategoryDTO().obs;
  RxInt roundPlaces = 0.obs;

  final rateEditingController = TextEditingController();
  final scaleEditingController = TextEditingController();
  final priceCommentEditingController = TextEditingController();


  var isRateValid = true.obs;
  var isScaleValid = true.obs;


  @override
  Future<void> onInit() async {
    super.onInit();

    selectedSale.listen((item) => refreshCategoryList());
    rateEditingController.addListener(() => isRateValid.value = double.tryParse(rateEditingController.text) != null);
    scaleEditingController.addListener(() => isScaleValid.value = double.tryParse(scaleEditingController.text) != null);

    rateEditingController.text = "1";
    scaleEditingController.text = "1";

    saleList.value = await apiService.getAllSales();
    selectedSale.value = saleList.first;
    isLoading.value = false;
  }

  refreshCategoryList() async{
    categoryList.value = await apiService.getAllSaleCategories(selectedSale.value.id!);
    selectedCategory.value = categoryList.first;
  }

  Future<void> transferTapped() async {
    await apiService.transferParserItemsToSale(ids, selectedCategory.value.id!,
        double.parse(rateEditingController.text),
        double.parse(scaleEditingController.text),
        priceCommentEditingController.text,
        roundPlaces.value);
    Get.back();
  }


}
