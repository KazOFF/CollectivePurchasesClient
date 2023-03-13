import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collective_purchases_client/common/extensions.dart';
import 'package:collective_purchases_client/pages/sale/index/sale_index_page_controller.dart';
import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper2/image_cropper2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openapi/openapi.dart';

class SaleEditPageController extends GetxController {
  final apiService = Get.find<ApiService>();
  var saleId = int.tryParse(Get.parameters["saleId"] ?? "");
  SaleDTO? sale;

  var nameEditingController = TextEditingController();
  var isNameValid = false.obs;
  var datesEditingController = TextEditingController();
  var saleCountry = SaleDTOCountryEnum.RUS.obs;
  var isActive = true.obs;
  var isFileChosen = false.obs;
  var filePath = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 7));



  @override
  Future<void> onInit() async {
    super.onInit();

    nameEditingController.addListener(() => isNameValid.value = nameEditingController.text.isNotEmpty);
    datesEditingController.text = "${startDate.toAppStringDayMonth()} - ${endDate.toAppStringDayMonth()}";

    if(saleId!=null){
      sale = await apiService.getSale(saleId!);
      nameEditingController.text = sale!.name!;
      saleCountry.value = sale!.country!;
      isActive.value = sale!.active!;
      startDate = sale!.startDate!;
      endDate = sale!.endDate!;
      datesEditingController.text = "${startDate.toAppStringDayMonth()} - ${endDate.toAppStringDayMonth()}";
    }
  }


  starDateButtonTapped() async {
    final results = await showCalendarDatePicker2Dialog(
      context: Get.context!,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      initialValue: [startDate, endDate],
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
    );

    if(results!=null && results.length==2){
      startDate = results[0]!;
      endDate = results[1]!;
      datesEditingController.text = "${startDate.toAppStringDayMonth()} - ${endDate.toAppStringDayMonth()}";
    }
  }

  pictureButtonTapped() async {
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

  Future<void> saveSale() async {

    if(saleId!=null){

      sale = await apiService.updateSale(
          saleId: saleId!,
          ownerId: sale!.ownerId!,
          name: nameEditingController.text.trim(),
          startDate:
          startDate,
          endDate: endDate,
          isActive: isActive.value,
          country: saleCountry.value,
          isPictureChanged: isFileChosen.value,
          picture: filePath);

    }else {
      sale = await apiService.createSale(
          name: nameEditingController.text.trim(),
          startDate: startDate,
          endDate: endDate,
          isActive: isActive.value,
          country: saleCountry.value,
          picture: filePath);
      saleId = sale!.id;
    }

    Get.offNamed("/sale/$saleId", arguments: sale);
    Get.find<SaleIndexPageController>().refreshList();
  }
}
