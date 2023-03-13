import 'package:get/get.dart';

import 'sale_item_index_page_controller.dart';

class SaleItemIndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaletemIndexPageController());
  }
}
