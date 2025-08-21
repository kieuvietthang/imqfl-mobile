import 'package:flutter/material.dart';

class Loading {
  const Loading._();

  static bool _isDialogOpen = false;

  static void show(BuildContext context) {
    if (_isDialogOpen) return;

    _isDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
      },
    ).then((_) {
      _isDialogOpen = false;
    });
  }

  static void hide(BuildContext context) {
    if (_isDialogOpen && Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogOpen = false;
    }
  }
}
