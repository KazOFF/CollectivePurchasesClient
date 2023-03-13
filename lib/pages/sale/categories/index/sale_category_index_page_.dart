import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:collective_purchases_client/widgets/empty_error_widget.dart';
import 'package:collective_purchases_client/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

import 'sale_category_index_page_controller.dart';

class SaleCategoryIndexPage
    extends GetView<SaleCategoryIndexPageController> {

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: Text(controller.sale.name ?? ""),
        bottom: PreferredSize(
            preferredSize: const Size(0, 6),
            child: Obx(() =>
            controller.isLoading.value
                ? LinearProgressIndicator(
              value: null,
              color: Get.theme.colorScheme.primary,
            )
                : const SizedBox.shrink())),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.categoryItemNewTapped(),
          backgroundColor: Get.theme.colorScheme.primary,
          foregroundColor: Get.theme.colorScheme.onPrimary,
          child: const Icon(Icons.add),
        ),
        body: Obx(() =>
            Container(padding: const EdgeInsets.all(16), child: _buildBody())));
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const LoadingWidget();
    } else if (controller.saleCategoryList.isEmpty) {
      return EmptyErrorWidget(onPressed: () => controller.refreshList());
    } else {
      return RefreshIndicator(
        onRefresh: controller.refreshList,
        child: ListView.separated(
          itemCount: controller.saleCategoryList.length,
          itemBuilder: _buildListItem,
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
        ),
      );
    }
  }

  Widget? _buildListItem(BuildContext context, int index) {
    SaleCategoryDTO item = controller.saleCategoryList[index];
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
          SlidableAction(
            onPressed:  (context) => controller.categoryItemEditTapped(index),
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
        ],
      ),
      child: ListTile(
        title: Text(item.name ?? ""),
        onTap: () => controller.categoryItemTapped(index),
      )
    );

  }


}
