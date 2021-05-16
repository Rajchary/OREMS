import 'package:flutter/material.dart';

void showToast(String message, BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 1, milliseconds: 500),
    action:
        SnackBarAction(label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
  ));
}
//Future<void> chooseImage() async{}
