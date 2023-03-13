import 'package:get/get.dart';

import 'parser_item_index_page_controller.dart';

class ParserItemIndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParserItemIndexPageController());
  }
}
