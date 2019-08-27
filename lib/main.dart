import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = "中国";

  List arrayData = [];

  // 省 市 区 id
  int provinceId = 0;
  int cityId = 0;
  int countyId = 0;

  @override
  void initState() {
    super.initState();

    _queryProvinces();
  }

  _queryProvinces() async {
    var url = 'http://guolin.tech/api/china';
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        setState(() {
          arrayData = data;
        });
      }
    } catch (ignore) {}
  }

  _queryCities() async {
    var url = 'http://guolin.tech/api/china/' + '$provinceId';
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        setState(() {
          arrayData = data;
        });
      }
    } catch (ignore) {}
  }

  _queryCounties() async {
    var url = 'http://guolin.tech/api/china/' + '$provinceId' + "/$cityId";
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        setState(() {
          arrayData = data;
        });
      }
    } catch (ignore) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: new ListView.builder(
            itemCount: arrayData.length,
            itemBuilder: (BuildContext context, int position) {
              var itemData = arrayData.elementAt(position);
              return getRow(itemData['name'], itemData['id']);
            }));
  }

  Widget getRow(String name, int code) {
    return new InkWell(
      child: new Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: new Text(name, style: new TextStyle(fontSize: 16)),
      ),
      onTap: () {
        setState(() {
          title = name;
        });

        if (provinceId == 0) {
          provinceId = code;
          _queryCities();
        } else if (cityId == 0) {
          cityId = code;
          _queryCounties();
        } else if (countyId == 0) {
          countyId = code;
        }
      },
    );
  }
}
