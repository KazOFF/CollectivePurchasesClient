import 'dart:ui';

import 'package:collective_purchases_client/common/error_handler.dart';
import 'package:collective_purchases_client/routes.dart';
import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:collective_purchases_client/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  var logger = Logger();
  var handler = GlobalErrorHandler();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    handler.onErrorDetails(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    return handler.onError(error, stack);
  };

  await initServices();


  final apiService = Get.find<ApiService>();
  //apiService.authToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJrYXpvdnJwQGdtYWlsLmNvbSIsImlzcyI6IkNvbGxlY3RpdmVQdXJjaGFzZXNTZXJ2ZXIiLCJpYXQiOjE2NzcxNzMwODYsImV4cCI6OTIyMzM3MjAzNjg1NDc3NX0._UU1FCW_lVtpU4X78nQs8mF_qpaoHEo9hGY1k17YcCL0v7JI6kTBVwejcMyo0ogg7SZGZQfltg3-Dpqa2rmM2A";

  String initialRoute = "/dashboard";
  final response = await apiService.checkAuth();
  if(!response){
    initialRoute = "/auth/login";
  }

  runApp(MyApp(route: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.route});
    final String route;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return GetMaterialApp(
      title: 'Совместные закупки',
      theme: appTheme,
      initialRoute: route,
      getPages: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}

initServices() async {
  print('starting services ...');
  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.
  await GetStorage.init();
  await Get.putAsync(() => ApiService().init(), permanent: true);

  //await Get.putAsync(() => DbService().init());
  //await Get.putAsync(SettingsService()).init();
  print('All services started...');
}
