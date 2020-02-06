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
  Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("实时统计"),
      ),
      body: WillPopScope(
        child: WebView(
          initialUrl: "https://news.qq.com/zt2020/page/feiyan.htm",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            _webViewController = webViewController;
          },
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
}
