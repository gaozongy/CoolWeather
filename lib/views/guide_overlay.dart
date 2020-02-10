import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 新功能导航
class Guide {
  static OverlayEntry show(
      BuildContext context, double rMargin, double tMargin, String message) {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          right: rMargin,
          top: tMargin,
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
