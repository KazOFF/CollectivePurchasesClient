import 'package:get/get.dart';

import 'shop_index_page_controller.dart';

class ShopIndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopIndexPageController());
  }
}
