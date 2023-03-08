import 'package:flutter/material.dart';

// void showSnackBar(BuildContext context, String text) {
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(
//       SnackBar(content: Text(text)),
//     );
// }

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBar(BuildContext context, String text) {
  scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(content: Text(text)),
  );
}
