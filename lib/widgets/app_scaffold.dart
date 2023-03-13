import 'package:collective_purchases_client/services/api_service-dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppScaffold extends StatelessWidget {
  Widget body;
  Text title;
  List<Widget>? actions;
  PreferredSizeWidget? bottom;
  Widget? floatingActionButton;

  AppScaffold({required this.body, required this.title, this.actions, this.bottom, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isMobile ? _buildMobileScaffold(context) : _buildDesktopScaffold(context);
  }

  Widget _buildMobileScaffold(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        title: title,
        automaticallyImplyLeading: _isHome(),
        leading: _leadingButton(),
        actions: actions,
        centerTitle: true,
        bottom: bottom,
      ),
      floatingActionButton: floatingActionButton,
      drawerEdgeDragWidth: Get.width*0.05,
      drawer: Padding(
        padding: EdgeInsets.only(top: statusBarHeight + appBarHeight),
        child: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _buildItems(),
                ),
              ),
              ListTile(
                title: const Text("Выход"),
                leading: const Icon(Icons.logout),
                selectedColor: Get.theme.textTheme.button?.color!,
                selectedTileColor: Get.theme.colorScheme.background,
                onTap: () => _logout(),
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: actions,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 200,
            height: 800,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: _buildItems(),
            ),
          ),
          const VerticalDivider(),
          Expanded(child: body),
        ],
      ),
    );
  }

  List<Widget> _buildItems() {
    return [
      ListTile(
        title: const Text("Закупки"),
        leading: const Icon(Icons.shopping_bag),
        selected: _isSelected("/sale"),
        selectedColor: Get.theme.textTheme.button?.color!,
        selectedTileColor: Get.theme.colorScheme.background,
        onTap: () => Get.offAllNamed("/sale"),
      ),
      const Divider(),
      ListTile(
        title: const Text("Задачи"),
        leading: const Icon(Icons.downloading),
        selected: _isSelected("/jobs"),
        selectedColor: Get.theme.textTheme.button?.color!,
        selectedTileColor: Get.theme.colorScheme.background,
        onTap: () => Get.offAllNamed("/jobs"),
      ),
      ListTile(
        title: const Text("Спарсенное"),
        leading: const Icon(Icons.folder_copy),
        selected: _isSelected("/parser"),
        selectedColor: Get.theme.textTheme.button?.color!,
        selectedTileColor: Get.theme.colorScheme.background,
        onTap: () => Get.offAllNamed("/parser"),
      ),
      ListTile(
        title: const Text("Сайты"),
        leading: const Icon(Icons.shopping_basket),
        selected: _isSelected("/shops"),
        selectedColor: Get.theme.textTheme.button?.color!,
        selectedTileColor: Get.theme.colorScheme.background,
        onTap: () => Get.offAllNamed("/shops"),
      ),
      const Divider(),
      ListTile(
        title: const Text("Пользователи"),
        leading: const Icon(Icons.people),
        selected: _isSelected("/users"),
        selectedColor: Get.theme.textTheme.button?.color!,
        selectedTileColor: Get.theme.colorScheme.background,
        onTap: () => Get.offAllNamed("/users"),
      ),
    ];
  }

  bool _isHome() {
    return Get.currentRoute.split("/").length < 3;
  }

  bool _isSelected(String path) {
    return Get.currentRoute.startsWith(path);
  }

  Widget? _leadingButton() {
    if (_isHome()) {
      return null;
    } else {
      return IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back));
    }
  }

  void _logout(){
    Get.find<ApiService>().logout();
    Get.offAllNamed("/auth/login");
  }
}
