import 'package:get/get.dart';

import 'sale_edit_page_controller.dart';

class SaleEditPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaleEditPageController());
  }
}
