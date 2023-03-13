import 'package:get/get.dart';

import 'shop_edit_page_controller.dart';

class ShopEditPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopEditPageController());
  }
}
