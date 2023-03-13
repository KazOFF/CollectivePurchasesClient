import 'package:get/get.dart';

import 'parser_transfer_page_controller.dart';

class ParserTransferPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParserTransferPageController());
  }
}
