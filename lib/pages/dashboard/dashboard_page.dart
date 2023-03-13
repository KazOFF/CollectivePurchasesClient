import 'package:collective_purchases_client/pages/dashboard/dashboard_page_controller.dart';
import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends GetView<DashboardPageController> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text("Совместные покупки"),
      bottom: PreferredSize(
          preferredSize: Size(0, 6),
          child: Obx(() => controller.isLoading.value ? Container(
            child: LinearProgressIndicator(
                  value: null,
                  color: Get.theme.colorScheme.primary,
                ),
          ) : SizedBox.shrink())),
      body: Column(
        children: [
          Container(
            child: Obx(() {
              return Text('Dashboard Body ${controller.isLock}');
            }),
          ),
        ],
      ),
    );
  }
}
