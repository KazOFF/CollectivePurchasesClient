import 'package:get/get.dart';

import 'parser_item_view_page_controller.dart';

class ParserItemViewPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParserItemViewPageController());
  }
}
