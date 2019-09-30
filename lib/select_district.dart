import 'dart:convert';
import 'package:coolweather/bean/focus_district_list_bean.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class SelectDistrict extends StatelessWidget {
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

  String province;
  String city;

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
      if (response.statusCode == HttpStatus.ok) {
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
            elevation: 1,
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
          province = name;
          _queryCities();
        } else if (cityId == 0) {
          cityId = code;
          city = name;
          _queryCounties();
        } else if (countyId == 0) {
          countyId = code;
          weatherId = weather;
          countyName = name;
        }

        if (!isEmpty(weatherId) && !isEmpty(countyName)) {
          Future<SharedPreferences> future = SharedPreferences.getInstance();
          future.then((prefs) {
            FocusDistrictListBean focusDistrictListBean;
            String focusCountyJson = prefs.getString('focus_district_data');
            if (!isEmpty(focusCountyJson)) {
              focusDistrictListBean =
                  FocusDistrictListBean.fromJson(json.decode(focusCountyJson));
            }

            if (focusDistrictListBean == null) {
              focusDistrictListBean =
                  new FocusDistrictListBean(new List<District>());
            }
            getLatLon(province + '省' + city + '市' + countyName).then((list) {
              focusDistrictListBean.districtList.add(District(
                  countyName, list.elementAt(0), list.elementAt(1))); // 北京坐标
              focusCountyJson = jsonEncode(focusDistrictListBean.toJson());
              prefs.setString('focus_district_data', focusCountyJson);
              Navigator.pop(context, true);
            });
          });
        }
      },
    );
  }

  Future<List<double>> getLatLon(String address) async {

    String parameter =
        'address=' + address + '&key=38366adde7d7ec1e94d652f9e90f78ce';

    String url = 'https://restapi.amap.com/v3/geocode/geo?' +
        parameter +
        '&sig=' +
        generateMd5(parameter);

    HttpClient httpClient = new HttpClient();
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        Map map = jsonDecode(json);
        List list = map['geocodes'];
        String location = list.elementAt(0)['location'];

        print('address:' + address + ' location:' + location);

        List<String> strList = location.split(',');
        List<double> latLon = [
          double.parse(strList[1]),
          double.parse(strList[0])
        ];
        return latLon;
      }
    } catch (ignore) {}

    return null;
  }

  // md5 加密
  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
}
