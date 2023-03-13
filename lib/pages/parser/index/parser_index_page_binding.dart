import 'package:get/get.dart';

import 'parser_index_page_controller.dart';

class ParserIndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParserIndexPageController());
  }
}
