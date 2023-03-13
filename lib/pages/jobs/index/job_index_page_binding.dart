import 'package:get/get.dart';

import 'job_index_page_controller.dart';

class JobIndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobIndexPageController());
  }
}
