import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Guide {
  static OverlayEntry show(
      BuildContext context, double x, double y, String message) {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          left: x,
          top: y,
          child: Material(
            color: Colors.transparent,
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Text(message),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("images/ic_guide_overlay.png"),
                fit: BoxFit.fill,
              )),
            ),
          ));
    });
    Overlay.of(context).insert(overlayEntry);
    return overlayEntry;
  }
}
