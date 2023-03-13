import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collective_purchases_client/widgets/app_scaffold.dart';
import 'package:collective_purchases_client/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'parser_item_view_page_controller.dart';

class ParserItemViewPage extends GetView<ParserItemViewPageController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
        title: Text(controller.parserItem.name ?? ""),
        bottom: PreferredSize(
            preferredSize: const Size(0, 6),
            child: controller.isLoading.value
                ? LinearProgressIndicator(
              value: null,
              color: Get.theme.colorScheme.primary,
            )
                : const SizedBox.shrink()),
        body: Container(padding: const EdgeInsets.all(16), child: _buildBody())));
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const LoadingWidget();
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(controller.parserItem.name!,
            style: Get.theme.textTheme.titleLarge,),
            const SizedBox(height: 8,),
            const Divider(),
            const SizedBox(height: 8,),
            CarouselSlider(
              options: CarouselOptions
                (
                aspectRatio: 1.5,
                enlargeCenterPage: false,
                viewportFraction: 0.5,
                ),
              items: controller.parserItem.pictures!.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: item.isNotEmpty
                                ? CachedNetworkImageProvider(controller.apiService.baseUrl+item)
                                : const AssetImage("assets/images/sale_no_image.png")
                            as ImageProvider,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        //child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8,),
            const Divider(),
            const SizedBox(height: 8,),
            Text("Цена",
            style: Get.theme.textTheme.titleLarge,),
            const SizedBox(height: 8,),
            Column(
              children: _buildPrices(),
            ),
            const SizedBox(height: 8,),
            const Divider(),
            const SizedBox(height: 8,),
            Text("Характеристики",
              style: Get.theme.textTheme.titleLarge,),
            const SizedBox(height: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildProperties(),
            ),
            const SizedBox(height: 8,),
            const Divider(),
            const SizedBox(height: 8,),
            Text("Описание",
              style: Get.theme.textTheme.titleLarge,),
            const SizedBox(height: 8,),
            Text(controller.parserItem.description!),
            const SizedBox(height: 8,),
            const Divider(),
            const SizedBox(height: 8,),
            Text("Ссылка",
              style: Get.theme.textTheme.titleLarge,),
            const SizedBox(height: 8,),
            InkWell(
              onTap: ()=> launchUrl(Uri.parse(controller.parserItem.url!)),
                child: Text(controller.parserItem.url!,
                style: const TextStyle(
                  color: Colors.blue,
                ),))
          ],
        ),
      );
    }
  }

  List<Widget> _buildPrices(){
     return controller.parserItem.prices!.toMap().entries.map((entry) =>
         Container(padding: const EdgeInsets.symmetric(vertical: 2),
           child: Row(
             children: [
               Text("${entry.key} - "),
               Text(entry.value.toStringAsFixed(2),
               style: Get.theme.textTheme.labelLarge,),
             ],
           ),
         )
     ).toList();
  }

  List<Widget> _buildProperties(){
    return controller.parserItem.properties!.isNotEmpty ? controller.parserItem.properties!.toMap().entries.map((entry) =>
        Container(padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Text("${entry.key} - "),
              Text(entry.value,
                style: Get.theme.textTheme.labelLarge,),
            ],
          ),
        )
    ).toList() : [const Text("Нет характеристик")];
  }


}
