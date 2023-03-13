import 'package:collective_purchases_client/pages/dashboard/dashboard_page_controller.dart';
import 'package:get/get.dart';

class DashboardPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardPageController());
  }
}