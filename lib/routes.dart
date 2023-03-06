import 'package:collective_purchases_client/pages/auth/login_page/login_page.dart';
import 'package:collective_purchases_client/pages/auth/login_page/login_page_binding.dart';
import 'package:collective_purchases_client/pages/auth/register_page/register_page.dart';
import 'package:collective_purchases_client/pages/auth/register_page/register_page_binding.dart';
import 'package:get/get.dart';

final appRoutes = [
  GetPage(name: "/auth/login", page: () => LoginPage(), binding: LoginPageBinding(), transition: Transition.upToDown),
  GetPage(name: "/auth/register", page: () => RegisterPage(), binding: RegisterPageBinding(), transition: Transition.downToUp),

];