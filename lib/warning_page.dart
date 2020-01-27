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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: WebView(
        initialUrl: "https://news.qq.com/zt2020/page/feiyan.htm",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      onWillPop: () async {
        _controller.future.then((webViewController) {
          Future<bool> canGoBack = webViewController.canGoBack();
          canGoBack.then((bool) {
            if (bool) {
              webViewController.goBack();
            } else {
              Navigator.of(context).pop();
            }
          });
        });
        return false;
      },
    );
  }
}
