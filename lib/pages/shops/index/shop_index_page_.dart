import 'package:cached_network_image/cached_network_image.dart';
import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:collective_purchases_client/widgets/empty_error_widget.dart';
import 'package:collective_purchases_client/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:openapi/openapi.dart';

import 'shop_index_page_controller.dart';

class ShopIndexPage extends GetView<ShopIndexPageController> {

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: const Text("Сайты"),
        bottom: PreferredSize(
            preferredSize: const Size(0, 6),
            child: Obx(() => controller.isLoading.value
                ? LinearProgressIndicator(
              value: null,
              color: Get.theme.colorScheme.primary,
            )
                : const SizedBox.shrink())),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.newShopItemTapped,
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
    } else if (controller.shopList.isEmpty) {
      return EmptyErrorWidget(onPressed: () => controller.refreshList());
    } else {
      return RefreshIndicator(
        onRefresh: controller.refreshList,
        child: ListView.builder(
          itemCount: controller.shopList.length,
          itemBuilder: _buildListItem,
        ),
      );
    }
  }

  Widget? _buildListItem(BuildContext context, int index) {
    ParserShopDTO item = controller.shopList[index];
    return Slidable(
        key: ValueKey(index),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) =>
                  controller.shopItemDeleteTapped(index),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
            SlidableAction(
              onPressed: (context) => controller.shopItemEditTapped(index),
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
              onTap: () => controller.shopItemTapped(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: item.picture!.isNotEmpty
                        ? CachedNetworkImageProvider(item.picture!)
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
                              item.name!,
                              style: TextStyle(
                                  fontSize:
                                  Get.theme.textTheme.titleMedium!.fontSize,
                                  color: Get.theme.colorScheme.onSecondary),
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

}
