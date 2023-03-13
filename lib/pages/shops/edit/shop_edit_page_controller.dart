import 'package:collective_purchases_client/pages/shops/index/shop_index_page_controller.dart';
import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper2/image_cropper2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openapi/openapi.dart';

class ShopEditPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var shopId = int.tryParse(Get.parameters["shopId"] ?? "");
  ParserShopDTO? shop;

  final nameEditingController = TextEditingController();
  final loginEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final baseUrlEditingController = TextEditingController();
  var isNeedLogin = true.obs;
  var isFileChosen = false.obs;

  var isNameValid = false.obs;
  var isBaseUrlValid = false.obs;
  var filePath = "";

  @override
  Future<void> onInit() async {
    super.onInit();

    nameEditingController.addListener(() => isNameValid.value = nameEditingController.text.isNotEmpty);
    baseUrlEditingController.addListener(() => isBaseUrlValid.value = baseUrlEditingController.text.isNotEmpty);

    if(shopId!=null){
      shop = await apiService.getShop(shopId!);
      nameEditingController.text = shop!.name!;
      baseUrlEditingController.text = shop!.baseUrl!;
      isNeedLogin.value = shop!.needLogin!;
      loginEditingController.text = shop!.login!;
      passwordEditingController.text = shop!.password!;
    }
  }





  Future<void> pictureButtonTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image !=null){
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 10),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Редактировать изображение',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if(croppedFile!=null){
        filePath = croppedFile.path;
        isFileChosen.value = true;
      }
    }
  }

  Future<void> saveButtonPressed() async {
    if(shopId!=null){

      shop = await apiService.updateShop(
          shopId: shopId!,
          name: nameEditingController.text,
          baseUrl: baseUrlEditingController.text,
          isNeedLogin: isNeedLogin.value,
          login: loginEditingController.text,
          password: passwordEditingController.text,
          picture: filePath,
          isPictureChanged: isFileChosen.value);

    }else {
      shop = await apiService.createShop(
          name: nameEditingController.text,
          baseUrl: baseUrlEditingController.text,
          isNeedLogin: isNeedLogin.value,
          login: loginEditingController.text,
          password: passwordEditingController.text,
          picture: filePath);
      shopId = shop!.id!;
    }

    Get.offNamed("/shops/$shopId", arguments: shop);
    Get.find<ShopIndexPageController>().refreshList();
  }
}
