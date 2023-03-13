import 'package:flutter/material.dart';

class EmptyErrorWidget extends StatelessWidget {
  final void Function() onPressed;

  EmptyErrorWidget({required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          "assets/images/status/empty_error.png",
          height: 200,
          fit: BoxFit.contain,
        ),
        TextButton(
            onPressed: onPressed, child: const Text("Обновить"))
      ],
    );
  }
}
