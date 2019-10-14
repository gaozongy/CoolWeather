import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class About extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutState();
  }
}

class AboutState extends State<About> {
  String appName = '';
  String version = '';

  @override
  void initState() {
    super.initState();

    _initData();
  }

  void _initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appName = packageInfo.appName;
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('关于'),
        elevation: 0,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  "images/ic_launcher.png",
                  width: 100,
                ),
                Text(appName + ' V'+ version)
              ],
            ),
            Positioned(
              bottom: 10,
              child: Text("bottom"),
            )
          ],
        ),
      ),
    );
  }
}
