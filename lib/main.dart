import 'package:collective_purchases_client/routes.dart';
import 'package:collective_purchases_client/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:openapi/api.dart';

Future<void> main() async {
  await GetStorage.init();
  String? authToken = GetStorage().read<String>("authToken");
  String initialRoute = "/dashboard";

  if(authToken==null){
    initialRoute = "/auth/login";
  }

  try {
    print("TRY");
    var response = await AuthenticationApi().check();
    if (response == null) {
      print("NULL");
      initialRoute = "/auth/login";
    }
  }on ApiException catch(ex){
    initialRoute = "/auth/login";
    print(ex.message);
  }

  runApp(MyApp(route: initialRoute,));
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
