import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("超人"),
      ),
      body: NimaActor(
        "assets/Robot.nima",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "Flight",
      ),
    );
  }
}
