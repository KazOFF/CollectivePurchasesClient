import 'package:collective_purchases_client/common/extensions.dart';
import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:collective_purchases_client/widgets/empty_error_widget.dart';
import 'package:collective_purchases_client/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

import 'parser_index_page_controller.dart';

class ParserIndexPage extends GetView<ParserIndexPageController> {

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: const Text("Спарсенное"),
        bottom: PreferredSize(
            preferredSize: const Size(0, 6),
            child: Obx(() =>
            controller.isLoading.value
                ? LinearProgressIndicator(
              value: null,
              color: Get.theme.colorScheme.primary,
            )
                : const SizedBox.shrink())),
        body: Obx(() =>
            Container(padding: const EdgeInsets.all(16), child: _buildBody())));
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const LoadingWidget();
    } else if (controller.parserCategoryList.isEmpty) {
      return EmptyErrorWidget(onPressed: () => controller.refreshList());
    } else {
      return RefreshIndicator(
        onRefresh: controller.refreshList,
        child: ListView.separated(
          itemCount: controller.parserCategoryList.length,
          itemBuilder: _buildListItem,
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
        ),
      );
    }
  }

  Widget? _buildListItem(BuildContext context, int index) {
    ParserCategoryDTO item = controller.parserCategoryList[index];
    return Slidable(
        key: ValueKey(index),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => controller.categoryItemDeleteTapped(index),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),

        child: ListTile(
          title: Text(item.name ?? ""),
          subtitle: Text(item.date!.toAppStringYearMonthDayWithTime()),
          onTap: () => controller.categoryItemTapped(index),
        )
    );

  }
}
