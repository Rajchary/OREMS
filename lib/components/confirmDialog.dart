import 'package:flutter/material.dart';

enum DialogAction { Yes, Cancel }

class AlertDialogs {
  static Future<DialogAction> confirmDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.Cancel),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.red[400], fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.Yes),
              child: Text(
                "Yes",
                style: TextStyle(
                    color: Colors.red[400], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.Cancel;
  }
}
