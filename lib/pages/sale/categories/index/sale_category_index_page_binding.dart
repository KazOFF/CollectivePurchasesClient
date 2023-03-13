import 'package:get/get.dart';

import 'sale_category_index_page_controller.dart';

class SaleCategoryIndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaleCategoryIndexPageController());
  }
}
