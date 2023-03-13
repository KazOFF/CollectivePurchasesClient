import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logout_page_controller.dart';

class LogoutPage extends GetView<LogoutPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выход')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text("Вы вышли из системы"),
          ],
        ),
      ),
    );
  }
}
