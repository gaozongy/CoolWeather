import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 警告信息页面
class WarningPage extends StatefulWidget {
  WarningPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WarningPageState();
  }
}

class WarningPageState extends State<WarningPage> {
  WebViewController _webViewController;

  /// 是否正在加载，WebView 加载完成后，页面还有其他请求，
  /// 为了流畅性，延迟一段时间显示 WebView
  bool hideWebView = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = createWebView();

    return Scaffold(
      appBar: AppBar(
        title: Text("实时追踪"),
        elevation: 0.6,
      ),
      body: WillPopScope(
        child: Stack(
          children: widgetList,
        ),
        onWillPop: () async {
          bool canGoBack = await _webViewController.canGoBack();
          if (canGoBack) {
            _webViewController.goBack();
          } else {
            Navigator.of(context).pop();
          }
          return false;
        },
      ),
    );
  }

  List<Widget> createWebView() {
    List<Widget> widgetList = List();
    if (hideWebView) {
      widgetList.add(Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
      ));
    }
    widgetList.add(Offstage(
      offstage: hideWebView,
      child: WebView(
        onPageFinished: (String url) {
          Future.delayed(Duration(milliseconds: 1200), () {
            setState(() {
              hideWebView = false;
            });
          });
        },
        initialUrl: "https://news.qq.com/zt2020/page/feiyan.htm",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
      ),
    ));
    return widgetList;
  }
}
