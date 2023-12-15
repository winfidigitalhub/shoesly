import 'package:flutter/material.dart';

class CustomTopSnackBar {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.deepPurple,
            padding: EdgeInsets.all(20.0),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Display for a short duration
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
