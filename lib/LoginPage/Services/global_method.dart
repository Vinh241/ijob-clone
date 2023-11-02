import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GlobalMethod {
  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Error Occurred'),
                )
              ],
            ),
            content: Text(
              error,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).canPop()
                        ? Navigator.of(context).pop()
                        : null;
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.red),
                  )),

            ],
          );
        });
  }

}
