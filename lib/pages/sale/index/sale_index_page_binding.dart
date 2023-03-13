import 'package:get/get.dart';

import 'sale_index_page_controller.dart';

class SaleIndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaleIndexPageController());
  }
}
