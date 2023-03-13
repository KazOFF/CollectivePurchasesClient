import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
          "assets/images/status/loading.png",
          height: 200,
          fit: BoxFit.contain,
        ));
  }
}
