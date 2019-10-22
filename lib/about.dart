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
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    "images/ic_launcher.png",
                    width: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      appName + ' V' + version,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 50),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '更新日志：',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '1.支持未来两小时雨势准确预测，轻松掌握天气\n2.支持设置单位，多个单位数值自由切换\n'
                            '3.添加关于页面，了解版本信息，更新介绍\n4.现在支持Android桌面小部件啦～',
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      '项目地址，https://github.com/GoodLuck-GL',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
