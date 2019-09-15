import 'dart:convert';
import 'package:coolweather/bean/focus_county_list_bean.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCounty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
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

  // 天气 id
  String weatherId;
  String countyName;

  bool isLoading;

  @override
  void initState() {
    super.initState();

    _queryProvinces();
  }

  _queryProvinces() async {
    var url = 'http://guolin.tech/api/china';
    _queryFromServer(url);
  }

  _queryCities() async {
    var url = 'http://guolin.tech/api/china/' + '$provinceId';
    _queryFromServer(url);
  }

  _queryCounties() async {
    var url = 'http://guolin.tech/api/china/' + '$provinceId' + "/$cityId";
    _queryFromServer(url);
  }

  _queryFromServer(String url) async {
    setState(() {
      isLoading = true;
    });

    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        setState(() {
          arrayData = data;
          isLoading = false;
        });
      }
    } catch (ignore) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (cityId != 0) {
          cityId = 0;
          _queryCities();
          return false;
        } else if (provinceId != 0) {
          provinceId = 0;
          _queryProvinces();
          return false;
        }
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                )
              : new ListView.builder(
                  itemCount: arrayData.length,
                  itemBuilder: (BuildContext context, int position) {
                    var itemData = arrayData.elementAt(position);
                    if (cityId != 0) {
                      return getRow(itemData['name'], itemData['id'],
                          itemData['weather_id']);
                    }
                    return getRow(itemData['name'], itemData['id'], "");
                  })),
    );
  }

  Widget getRow(String name, int code, String weather) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Text(name, style: new TextStyle(fontSize: 16)),
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
          weatherId = weather;
          countyName = name;
        }

        if (!isEmpty(weatherId) && !isEmpty(countyName)) {
          Future<SharedPreferences> future = SharedPreferences.getInstance();
          future.then((prefs) {
            FocusCountyListBean focusCountyListBean;
            String focusCountyJson = prefs.getString('focus_county_data');
            if (!isEmpty(focusCountyJson)) {
              focusCountyListBean =
                  FocusCountyListBean.fromJson(json.decode(focusCountyJson));
            }

            if (focusCountyListBean == null) {
              focusCountyListBean = new FocusCountyListBean(new List<County>());
            }
            focusCountyListBean.countyList.add(County(countyName, 0, 0));
            focusCountyJson = jsonEncode(focusCountyListBean.toJson());
            prefs.setString('focus_county_data', focusCountyJson);
            Navigator.pop(context, true);
          });
        }
      },
    );
  }
}
