import 'package:collective_purchases_client/pages/auth/login_page/login_page.dart';
import 'package:collective_purchases_client/pages/auth/login_page/login_page_binding.dart';
import 'package:collective_purchases_client/pages/auth/logout/logout_page.dart';
import 'package:collective_purchases_client/pages/auth/logout/logout_page_binding.dart';
import 'package:collective_purchases_client/pages/auth/register_page/register_page.dart';
import 'package:collective_purchases_client/pages/auth/register_page/register_page_binding.dart';
import 'package:collective_purchases_client/pages/dashboard/dashboard_page.dart';
import 'package:collective_purchases_client/pages/dashboard/dashboard_page_binding.dart';
import 'package:collective_purchases_client/pages/jobs/index/job_index_page_.dart';
import 'package:collective_purchases_client/pages/jobs/index/job_index_page_binding.dart';
import 'package:collective_purchases_client/pages/parser/index/parser_index_page_.dart';
import 'package:collective_purchases_client/pages/parser/index/parser_index_page_binding.dart';
import 'package:collective_purchases_client/pages/parser/items/index/parser_item_index_page_.dart';
import 'package:collective_purchases_client/pages/parser/items/index/parser_item_index_page_binding.dart';
import 'package:collective_purchases_client/pages/parser/items/view/parser_item_view_page_.dart';
import 'package:collective_purchases_client/pages/parser/items/view/parser_item_view_page_binding.dart';
import 'package:collective_purchases_client/pages/parser/transfer/parser_transfer_page_.dart';
import 'package:collective_purchases_client/pages/parser/transfer/parser_transfer_page_binding.dart';
import 'package:collective_purchases_client/pages/sale/categories/index/sale_category_index_page_.dart';
import 'package:collective_purchases_client/pages/sale/categories/index/sale_category_index_page_binding.dart';
import 'package:collective_purchases_client/pages/sale/categories/items/index/sale_item_index_page_.dart';
import 'package:collective_purchases_client/pages/sale/categories/items/index/sale_item_index_page_binding.dart';
import 'package:collective_purchases_client/pages/sale/categories/items/view/catalog_item_view_page_.dart';
import 'package:collective_purchases_client/pages/sale/categories/items/view/catalog_item_view_page_binding.dart';
import 'package:collective_purchases_client/pages/sale/edit/sale_edit_page_.dart';
import 'package:collective_purchases_client/pages/sale/edit/sale_edit_page_binding.dart';
import 'package:collective_purchases_client/pages/sale/index/sale_index_page_.dart';
import 'package:collective_purchases_client/pages/sale/index/sale_index_page_binding.dart';
import 'package:collective_purchases_client/pages/shops/edit/shop_edit_page_.dart';
import 'package:collective_purchases_client/pages/shops/edit/shop_edit_page_binding.dart';
import 'package:collective_purchases_client/pages/shops/index/shop_index_page_.dart';
import 'package:collective_purchases_client/pages/shops/index/shop_index_page_binding.dart';
import 'package:get/get.dart';

final appRoutes = [
  GetPage(name: "/auth/login", page: () => LoginPage(), binding: LoginPageBinding(), transition: Transition.upToDown),
  GetPage(name: "/auth/logout", page: () => LogoutPage(), binding: LogoutPageBinding()),
  GetPage(name: "/auth/register", page: () => RegisterPage(), binding: RegisterPageBinding(), transition: Transition.downToUp),

  GetPage(name: "/dashboard", page: () => DashboardPage(), binding: DashboardPageBinding()),

  GetPage(name: "/sale", page: () => SaleIndexPage(), binding: SaleIndexPageBinding()),
  GetPage(name: "/sale/new", page: () => SaleEditPage(), binding: SaleEditPageBinding()),
  GetPage(name: "/sale/:saleId", page: () => SaleCategoryIndexPage(), binding: SaleCategoryIndexPageBinding()),
  GetPage(name: "/sale/:saleId/edit", page: () => SaleEditPage(), binding: SaleEditPageBinding()),
  GetPage(name: "/sale/:saleId/:saleCategoryId", page: () => SaleItemIndexPage(), binding: SaleItemIndexPageBinding()),
  GetPage(name: "/sale/:saleId/:saleCategoryId/:saleItemId", page: () => SaleItemViewPage(), binding: SaleItemViewPageBinding()),


  GetPage(name: "/shops", page: () => ShopIndexPage(), binding: ShopIndexPageBinding()),
  GetPage(name: "/shops/new", page: () => ShopEditPage(), binding: ShopEditPageBinding()),
  GetPage(name: "/shops/:shopId/edit", page: () => ShopEditPage(), binding: ShopEditPageBinding()),

  GetPage(name: "/jobs", page: () => JobIndexPage(), binding: JobIndexPageBinding()),

  GetPage(name: "/parser", page: () => ParserIndexPage(), binding: ParserIndexPageBinding()),
  GetPage(name: "/parser/transfer", page: () => ParserTransferPage(), binding: ParserTransferPageBinding()),
  GetPage(name: "/parser/:parserCategoryId", page: () => ParserItemIndexPage(), binding: ParserItemIndexPageBinding()),
  GetPage(name: "/parser/:parserCategoryId/:parserItemId", page: ()=>ParserItemViewPage(), binding: ParserItemViewPageBinding()),



];