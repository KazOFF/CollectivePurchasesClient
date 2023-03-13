import 'package:cached_network_image/cached_network_image.dart';
import 'package:collective_purchases_client/common/extensions.dart';
import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:collective_purchases_client/widgets/empty_error_widget.dart';
import 'package:collective_purchases_client/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

import 'sale_index_page_controller.dart';

class SaleIndexPage extends GetView<SaleIndexPageController> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: const Text("Закупки"),
        bottom: PreferredSize(
            preferredSize: const Size(0, 6),
            child: Obx(() => controller.isLoading.value
                ? LinearProgressIndicator(
                    value: null,
                    color: Get.theme.colorScheme.primary,
                  )
                : const SizedBox.shrink())),
        actions: [_buildPopupMenu()],
        floatingActionButton: FloatingActionButton(
          onPressed: controller.newSaleItemTapped,
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
    } else if (controller.saleList.isEmpty) {
      return EmptyErrorWidget(onPressed: () => controller.refreshList());
    } else {
      return RefreshIndicator(
        onRefresh: controller.refreshList,
        child: ListView.builder(
          itemCount: controller.saleList.length,
          itemBuilder: _buildListItem,
        ),
      );
    }
  }

  Widget? _buildListItem(BuildContext context, int index) {
    SaleDTO item = controller.saleList[index];
    return Slidable(
        key: ValueKey(index),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) =>
                  controller.categoryItemDeleteTapped(index),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
            SlidableAction(
              onPressed: (context) => controller.categoryItemEditTapped(index),
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
          ],
        ),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 5,
            child: InkWell(
              onTap: () => controller.saleItemTapped(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: item.picture!.isNotEmpty
                        ? CachedNetworkImageProvider(controller.apiService.baseUrl+item.picture!)
                        : const AssetImage("assets/images/sale_no_image.png")
                            as ImageProvider,
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ),
                ),
                child: SizedBox.fromSize(
                  size: const Size.fromHeight(200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 25,
                        width: 40,
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/country/${item.country!.name}.png",
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(150, 255, 255, 255),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                        child: Column(
                          children: [
                            Text(
                              item.name!,
                              style: TextStyle(
                                  fontSize:
                                      Get.theme.textTheme.titleMedium!.fontSize,
                                  color: Get.theme.colorScheme.onSecondary),
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Text(
                                  "${item.startDate!.toAppStringDayMonth()} - ${item.endDate!.toAppStringDayMonth()}",
                                  style: TextStyle(
                                      color: Get.theme.colorScheme.onSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<SortType>(
        icon: const Icon(Icons.sort),
        onSelected: controller.sortList,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SortType>>[
              const PopupMenuItem<SortType>(
                value: SortType.name,
                child: Text('По имени'),
              ),
              const PopupMenuItem<SortType>(
                value: SortType.startDate,
                child: Text('По дате начала'),
              ),
              const PopupMenuItem<SortType>(
                value: SortType.endDate,
                child: Text('По дате конца'),
              ),
            ]);
  }
}
