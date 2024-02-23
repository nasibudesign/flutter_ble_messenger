import 'package:flutter/material.dart';

Future<void> showAlertDialogBox(
    {required BuildContext context,
    required String header,
    required String message,
    required List<Widget> actionButtons}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: Text(header),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text(message)],
          ),
        ),
        actions: actionButtons,
      );
    },
  );
}
