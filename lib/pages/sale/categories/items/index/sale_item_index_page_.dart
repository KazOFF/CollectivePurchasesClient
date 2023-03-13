import 'package:cached_network_image/cached_network_image.dart';
import 'package:collective_purchases_client/common/extensions.dart';
import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:collective_purchases_client/widgets/empty_error_widget.dart';
import 'package:collective_purchases_client/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'sale_item_index_page_controller.dart';

class SaleItemIndexPage extends GetView<SaletemIndexPageController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
        title: Text(controller.saleCategory.name ?? ""),
        bottom: PreferredSize(
            preferredSize: const Size(0, 6),
            child: Obx(() => controller.isLoading.value
                ? LinearProgressIndicator(
                    value: null,
                    color: Get.theme.colorScheme.primary,
                  )
                : const SizedBox.shrink())),
        floatingActionButton: _buildFab(),
        actions: _buildActions(),
        body: Obx(() => Container(
            padding: const EdgeInsets.all(16), child: _buildBody()))));
  }

  Widget _buildBody() {
    final colCount = (Get.width / 300).round();
    if (controller.isLoading.value) {
      return const LoadingWidget();
    } else if (controller.saleItemList.isEmpty) {
      return EmptyErrorWidget(onPressed: () => controller.refreshList());
    } else {
      return RefreshIndicator(
        onRefresh: controller.refreshList,
        child: GridView.builder(
          itemCount: controller.saleItemList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            maxCrossAxisExtent: 300,
            childAspectRatio: 0.75,
          ),
          itemBuilder: _buildGridItem,
        ),
      );
    }
  }

  Widget? _buildGridItem(BuildContext context, int index) {
    SaleItemDTO item = controller.saleItemList[index];
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 5,
        child: InkWell(
          onTap: () => controller.parserItemTapped(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: controller.isSelected(index) ? Get.theme.colorScheme.primary : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: item.pictures!.isNotEmpty
                    ? CachedNetworkImageProvider(controller.apiService.baseUrl+item.pictures!.first)
                    : const AssetImage("assets/images/sale_no_image.png")
                        as ImageProvider,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(150, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        item.name!.truncateTo(30),
                        style: TextStyle(
                            fontSize: Get.theme.textTheme.titleMedium!.fontSize,
                            color: Get.theme.colorScheme.onSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> _buildActions() {
    return [
      controller.isSelectionMode.value ? Center(child: Text(controller.selectedItems.length.toString())) : const SizedBox.shrink(),
      IconButton(
          onPressed: () => controller.isSelectionMode.toggle(),
          icon: Icon(
            Icons.edit_note,
            color: controller.isSelectionMode.value
                ? Get.theme.colorScheme.primary
                : null,
          )),
    ];
  }

  Widget? _buildFab(){
    return controller.isSelectionMode.value ? SpeedDial(
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.select_all),
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey,
          onPressed: controller.selectAllTapped,
        ),
        SpeedDialChild(
          child: const Icon(Icons.delete),
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          onPressed: controller.batchDeleteTapped,
        ),
      ],
      labelsBackgroundColor: Get.theme.colorScheme.background,
      closedForegroundColor: Colors.white,
      openForegroundColor: Colors.white,
      closedBackgroundColor: Get.theme.colorScheme.primary,
      openBackgroundColor: Get.theme.colorScheme.primary,
      child: const Icon(Icons.menu),
    ) : null;
  }

}
