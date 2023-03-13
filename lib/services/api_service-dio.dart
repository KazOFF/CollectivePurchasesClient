import 'package:collective_purchases_client/common/cp_server_exceptions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:openapi/openapi.dart';

class ApiService extends getx.GetxService {
  final String baseUrl = "http://192.168.1.53:8080/";
  final Openapi _openapi =
      Openapi(basePathOverride: "http://192.168.1.53:8080");
  late GetStorage _storage;

  Future<ApiService> init() async {
    _storage = GetStorage();
    _openapi.dio.options.validateStatus = (status) => status! < 300;
    authToken = _storage.read("authToken");
    return this;
  }

  set authToken(String? token) {
    if (token == null) {
      _storage.remove("authToken");
      _openapi.dio.options.headers.remove("Authorization");
    } else {
      _storage.write("authToken", token);
      _openapi.dio.options.headers.assign("Authorization", "Bearer $token");
    }
  }

  Future<bool> checkAuth() async {
    try {
      if (_storage.read("authToken") == null) {
        return false;
      }
      await _openapi.getAuthenticationApi().check();
      return true;
    } on DioError catch (ex) {
      return false;
    }
    return false;
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      final requestBuilder = LoginRequestBuilder()
        ..email = email
        ..password = password;
      final response = await _openapi
          .getAuthenticationApi()
          .login(loginRequest: requestBuilder.build());
      authToken = response.data!.token;
      return true;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  void logout() {
    authToken = null;
  }

  Future<List<SaleDTO>> getAllSales() async {
    try {
      final response = await _openapi.getSaleApi().getAllSales();
      return response.data?.toList() ?? <SaleDTO>[];
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<SaleDTO> getSale(int saleId) async {
    try {
      final response = await _openapi.getSaleApi().getSale(saleId: saleId);
      return response.data!;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<SaleDTO> createSale({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required SaleDTOCountryEnum country,
    required String picture,
  }) async {
    try {
      if (picture.isNotEmpty) {
        picture = await uploadPicture(picture);
      }
      final builder = SaleDTOBuilder()
        ..name = name
        ..startDate = startDate.toUtc()
        ..endDate = endDate.toUtc()
        ..active = isActive
        ..country = country
        ..picture = picture.replaceAll("\\", "/");

      SaleDTO sale =
          (await _openapi.getSaleApi().createSale(saleDTO: builder.build()))
              .data!;
      return sale;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<SaleDTO> updateSale({
    required int saleId,
    required int ownerId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required SaleDTOCountryEnum country,
    required bool isPictureChanged,
    required String picture,
  }) async {
    try {
      if (isPictureChanged) {
        picture = await uploadPicture(picture);
      }
      final builder = SaleDTOBuilder()
        ..id = saleId
        ..ownerId = ownerId
        ..name = name
        ..startDate = startDate.toUtc()
        ..endDate = endDate.toUtc()
        ..active = isActive
        ..country = country
        ..picture = picture;

      SaleDTO sale = (await _openapi
              .getSaleApi()
              .updateSale(saleId: saleId, saleDTO: builder.build()))
          .data!;
      return sale;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> deleteSale(int saleId) async {
    try {
      await _openapi.getSaleApi().deleteSale(saleId: saleId);
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<List<SaleCategoryDTO>> getAllSaleCategories(int saleId) async {
    try {
      final response = await _openapi
          .getSaleCategoryApi()
          .getAllSaleCategories(saleId: saleId);
      return response.data?.toList() ?? <SaleCategoryDTO>[];
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> createSaleCategory(int saleId, String name) async {
    try {
      final builder = SaleCategoryDTOBuilder()
        ..name = name
        ..saleId = saleId;
      await _openapi
          .getSaleCategoryApi()
          .createSaleCategory(saleId: saleId, saleCategoryDTO: builder.build());
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> updateSaleCategory(
      int saleId, int saleCategoryId, String name) async {
    try {
      final builder = SaleCategoryDTOBuilder()
        ..id = saleCategoryId
        ..name = name
        ..saleId = saleId;
      await _openapi.getSaleCategoryApi().updateSaleCategory(
          saleCategoryId: saleCategoryId,
          saleId: saleId,
          saleCategoryDTO: builder.build());
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> deleteSaleCategory(int saleId, int saleCategoryId) async {
    try {
      await _openapi
          .getSaleCategoryApi()
          .deleteSaleCategory(saleId: saleId, saleCategoryId: saleCategoryId);
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<List<SaleItemDTO>> getAllSaleItems(int saleCategoryId) async {
    try {
      final response = await _openapi
          .getSaleItemApi()
          .getAllSaleItems(saleId: 0, saleCategoryId: saleCategoryId);
      return response.data?.toList() ?? <SaleItemDTO>[];
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<SaleItemDTO> getSaleItem(int saleId, int saleCategoryId, int saleItemId) async {
    try {
      final response = await _openapi
          .getSaleItemApi().getSaleItem(saleId: saleId, saleCategoryId: saleCategoryId, saleItemId: saleItemId);
      return response.data ?? SaleItemDTO();
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> batchDeleteSaleItems(List<int> ids) async {
    try {
      await _openapi.getSaleItemApi().batchDeleteSaleItem(saleId: 0, saleCategoryId: 0, requestBody: ids.build());
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<List<ParserShopDTO>> getAllShops() async {
    try {
      final response = await _openapi.getParserShopApi().getAllParserShops();
      return response.data?.toList() ?? <ParserShopDTO>[];
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<ParserShopDTO> getShop(int shopId) async {
    try {
      final response =
          await _openapi.getParserShopApi().getParserShop(parserShopId: shopId);
      return response.data!;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<ParserShopDTO> createShop({
    required String name,
    required String baseUrl,
    required bool isNeedLogin,
    required String login,
    required String password,
    required String picture,
  }) async {
    try {
      if (picture.isNotEmpty) {
        picture = await uploadPicture(picture);
      }
      final builder = ParserShopDTOBuilder()
        ..name = name
        ..baseUrl = baseUrl
        ..needLogin = isNeedLogin
        ..login = login
        ..password = password
        ..picture = picture.replaceAll("\\", "/");

      ParserShopDTO shop = (await _openapi
              .getParserShopApi()
              .createParserShop(parserShopDTO: builder.build()))
          .data!;
      return shop;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<ParserShopDTO> updateShop(
      {required int shopId,
      required String name,
      required String baseUrl,
      required bool isNeedLogin,
      required String login,
      required String password,
      required String picture,
      required bool isPictureChanged}) async {
    try {
      if (isPictureChanged) {
        picture = await uploadPicture(picture);
      }
      final builder = ParserShopDTOBuilder()
        ..id = shopId
        ..name = name
        ..baseUrl = baseUrl
        ..needLogin = isNeedLogin
        ..login = login
        ..password = password
        ..picture = picture.replaceAll("\\", "/");

      ParserShopDTO shop = (await _openapi.getParserShopApi().updateParserShop(
              parserShopId: shopId, parserShopDTO: builder.build()))
          .data!;
      return shop;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> deleteShop(int shopId) async {
    try {
      await _openapi.getParserShopApi().deleteParserJob(parserShopId: shopId);
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<List<ParserJobDTO>> getAllJobs() async {
    try {
      final response = await _openapi.getParserJobApi().getAllParserJobs();
      return response.data?.toList() ?? <ParserJobDTO>[];
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> createJob(String url, int shopId) async {
    try {
      final builder = ParserJobDTOBuilder()
      ..url = url
      ..parserShopId = shopId;
      await _openapi.getParserJobApi().createParserJob(parserJobDTO: builder.build());
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> deleteJob(int jobId) async {
    try {
      await _openapi.getParserJobApi().deleteParserJob1(parserJobId: jobId);
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> refreshJob(int jobId) async {
    try {
      await _openapi.getParserJobApi().refreshParserJob(parserJobId: jobId);
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<List<ParserCategoryDTO>> getAllParserCategories() async {
    try {
      final response = await _openapi.getParserCategoryApi().getAllParserCategories();
      return response.data?.toList() ?? <ParserCategoryDTO>[];
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> deleteParserCategory(int categoryId) async {
    try {
      await _openapi.getParserCategoryApi().deleteParserCategory(parserCategoryId: categoryId);
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }



  Future<List<ParserItemDTO>> getAllParserItems(int parserCategoryId) async {
    try {
      final response = await _openapi.getParserItemApi().getAllParserItems(parserCategoryId: parserCategoryId);
      return response.data?.toList() ?? <ParserItemDTO>[];
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<ParserItemDTO> getParserItem(int parserCategoryId, int parserItemId) async {
    try {
      final response = await _openapi.getParserItemApi().getParserItem(parserCategoryId: parserCategoryId, parserItemId: parserItemId);
      return response.data!;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> deleteParserItem(int parserCategoryId, int parserItemId) async {
    try {
      await _openapi.getParserItemApi().deleteParserItem(parserCategoryId: parserCategoryId, parserItemId: parserItemId);

      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> batchDeleteParserItems(List<int> ids, int parserCategoryId) async {
    try {
      await _openapi.getParserItemApi().batchDeleteParserItem(parserCategoryId: parserCategoryId, requestBody: ids.build());
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }

  Future<void> transferParserItemsToSale(List<int> ids, int saleCategoryId, double rate, double scale, String priceComment, int roundPlaces) async {
    try {
      final builder = ParserItemTransferRequestBuilder()
      ..parserItemList = ListBuilder(ids)
      ..saleCategoryId = saleCategoryId
      ..rate = rate
      ..scale = scale
      ..priceComment = priceComment
      ..roundPlaces = roundPlaces;

      await _openapi.getParserItemApi().transferToSale(parserCategoryId: 0, parserItemTransferRequest: builder.build());
      return;
    } on DioError catch (ex) {
      _unwrapError(ex);
    }
    throw UnknownException();
  }


  void _unwrapError(DioError ex) {
    if (ex.response == null) {
      throw UnknownException();
    } else {
      switch (ex.response!.statusCode) {
        case 401:
          throw NotAuthenticatedException();
        default:
          throw ServerException(ex.response!.data["message"]);
      }
    }
  }

  Future<String> uploadPicture(String filePath) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath),
    });
    final response =
        await _openapi.dio.post("${baseUrl}catalog/picture", data: formData);
    return response.data["picture"];
  }
}
