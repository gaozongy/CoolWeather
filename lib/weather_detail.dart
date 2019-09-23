import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amap_location/amap_location.dart';

import 'bean/daily.dart';
import 'bean/focus_county_list_bean.dart';
import 'bean/hourly.dart';
import 'bean/minutely.dart';
import 'bean/realtime.dart';
import 'bean/weather_bean.dart';
import 'global.dart';
import 'utils/date_utils.dart';
import 'utils/translation_utils.dart';
import 'views/popup_window_button.dart';
import 'views/temp_line.dart';

String time = '未知';

class WeatherDetail extends StatefulWidget {
  WeatherDetail({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainLayoutState();
  }
}

class _MainLayoutState extends State<WeatherDetail> {
  List<County> countyList = new List();

  int currentPage = 0;

  County county;

  PageController _pageController = new PageController();

  /// 是否已取得定位
  bool position = false;

  @override
  void initState() {
    super.initState();

    county = County('未知', 0, 0);
    countyList.add(county);

    _initPageController();
    _initLocation();
    _initData();
  }

  _initPageController() {
    _pageController.addListener(() {
      int page = (_pageController.page + 0.5).toInt();
      if (page != currentPage) {
        setState(() {
          currentPage = page;
          county = countyList.elementAt(page);
        });
      }
    });
  }

  _initLocation() async {
    bool result = await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));

    if (result) {
      AMapLocation aMapLocation = await AMapLocationClient.getLocation(true);
      setState(() {
        List<County> list = List();

        if (aMapLocation.district == null ||
            aMapLocation.latitude == null ||
            aMapLocation.longitude == null) {
          return;
        }

        County posCounty = new County(aMapLocation.district,
            aMapLocation.latitude, aMapLocation.longitude);
        list.add(posCounty);

        if (currentPage == 0) {
          county = posCounty;
        }
        countyList.replaceRange(0, 1, list);

        position = true;
      });
    }
  }

  _initData() {
    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      String focusCountyListJson = prefs.getString('focus_county_data');
      if (focusCountyListJson != null) {
        FocusCountyListBean focusCountyListBean =
            FocusCountyListBean.fromJson(json.decode(focusCountyListJson));
        if (focusCountyListBean != null &&
            focusCountyListBean.countyList.length > 0) {
          setState(() {
            countyList.addAll(focusCountyListBean.countyList);
          });
          return;
        }
      }
    });
  }

  _focusCountyList() {
    Navigator.of(context).pushNamed("focus_county_list").then((bool) {
      if (bool) {
        _initData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Stack(
            children: <Widget>[
              position
                  ? Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: countyList.length,
                        itemBuilder: (BuildContext context, int position) {
                          return _WeatherDetailWidget(
                              countyList.elementAt(position));
                        },
                      ),
                    )
                  : Center(child: Text('获取定位 Loading 动画')),
              _titleLayout(),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: currentPage % 2 == 0
                ? AssetImage('image/sunny.jpg')
                : AssetImage('image/green.jpg'),
            fit: BoxFit.fitHeight,
          ))),
    );
  }

  Widget _titleLayout() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              currentPage == 0
                  ? Padding(
                      padding: EdgeInsets.only(left: 22),
                      child: Image(
                        image: AssetImage("image/location_ic.png"),
                        width: 22,
                        color: Colors.white60,
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      county != null ? county.countyName : '未知',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                color: Colors.white,
                onPressed: _focusCountyList,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: PopupWindowButton(
                    offset: Offset(0, 100),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    window: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 15, 60, 15),
                          child: Text(
                            'share',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          child: Text(
                            'about',
                            style: TextStyle(fontSize: 16),
                          ),
                          padding: EdgeInsets.fromLTRB(15, 15, 60, 15),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    AMapLocationClient.shutdown();
    super.dispose();
  }
}

class _WeatherDetailWidget extends StatefulWidget {
  final County county;

  _WeatherDetailWidget(this.county);

  @override
  State<StatefulWidget> createState() {
    return _WeatherDetailState(county);
  }
}

class _WeatherDetailState extends State<_WeatherDetailWidget> {
  County county;

  WeatherBean weatherBean;

  Result result;

  Realtime realtime;

  Minutely minutely;

  Hourly hourly;

  Daily daily;

  _WeatherDetailState(this.county);

  @override
  void initState() {
    super.initState();

    _queryWeather(county.longitude, county.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return weatherDetailLayout(context);
  }

  Widget weatherDetailLayout(BuildContext context) {
    if (weatherBean != null) {
      return RefreshIndicator(
        onRefresh: () => _queryWeather(county.longitude, county.latitude),
        child: ListView(
          children: <Widget>[
            _tempLayout(),
            _weatherLayout(),
            _fromLayout(),
            _forecastLayout(),
            _tempLineLayout(),
//            _aqiLayout(),
//            _suggestionLayout(),
          ],
        ),
      );
    } else {
      return Center(
        child: Text('天气数据获取 Loading 动画'),
      );
    }
  }

  Widget _tempLayout() {
    return Padding(
      padding: EdgeInsets.fromLTRB(28, 370, 28, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${(realtime.temperature + 0.5).toInt()}°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60,
              decoration: TextDecoration.none,
            ),
          )
        ],
      ),
    );
  }

  Widget _weatherLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            Translation.getWeatherDesc(realtime.skycon),
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }

  Widget _fromLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            result.forecast_keypoint,
            style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }

  Widget _forecastLayout() {
    List<Widget> forecastRow = new List();
    int length = daily.skycon.length;
    for (int i = 0; i < length; i++) {
      Skycon skycon = daily.skycon.elementAt(i);
      DateTime dateTime = DateTime.parse(skycon.date);
      ImageIcon imageIcon = _getWeatherIcon(skycon.value);

      forecastRow.add(Column(
        children: <Widget>[
          _textLayout(DateUtils.getWeekday(dateTime.weekday)),
          _textLayout('${dateTime.month}' + '月' + '${dateTime.day}' + '日'),
          Padding(
            padding: EdgeInsets.only(top: 8),
            //child: Icon(imageIcon, color: Colors.white),
            child: imageIcon,
          ),
          _textLayout(Translation.getWeatherDesc(skycon.value)),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 30, 12, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: forecastRow,
      ),
    );
  }

  Widget _textLayout(String content) {
    return Text(content,
        style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            decoration: TextDecoration.none));
  }

  ImageIcon _getWeatherIcon(String weather) {
    ImageIcon imageIcon;
    switch (weather) {
      case 'CLEAR_DAY':
      case 'CLEAR_NIGHT':
        {
          imageIcon = ImageIcon(
            AssetImage('image/cw_sunny.png'),
            size: 25.0,
            color: Colors.white,
          );
        }
        break;
      case 'PARTLY_CLOUDY_DAY':
      case 'PARTLY_CLOUDY_NIGHT':
        {
          imageIcon = ImageIcon(
            AssetImage('image/cw_cloud.png'),
            size: 25.0,
            color: Colors.white,
          );
        }
        break;
      case 'CLOUDY':
        {
          imageIcon = ImageIcon(
            AssetImage('image/cl_nosun.png'),
            size: 25.0,
            color: Colors.white,
          );
        }
        break;
      case 'WIND':
        break;
      case 'HAZE':
        {
          imageIcon = ImageIcon(
            AssetImage('image/cw_haze.png'),
            size: 25.0,
            color: Colors.white,
          );
        }
        break;
      case 'RAIN':
        {
          imageIcon = ImageIcon(
            AssetImage('image/cl_rain.png'),
            size: 25.0,
            color: Colors.white,
          );
        }
        break;
      case 'SNOW':
        {
          imageIcon = ImageIcon(
            AssetImage('image/cw_snow.png'),
            size: 25.0,
            color: Colors.white,
          );
        }
        break;
      default:
        break;
    }
    return imageIcon;
  }

  Widget _tempLineLayout() {
    List<Temp> tempList = List();

    var forecast = daily.temperature;
    for (int i = 0; i < forecast.length; i++) {
      tempList.add(Temp(forecast.elementAt(i).max, forecast.elementAt(i).min));
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TempLineWidget(tempList),
    );
  }

  //空气质量
//  Widget _aqiLayout() {
//    return Container(
//      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//      child: Column(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Text("空气质量",
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 20,
//                      decoration: TextDecoration.none))
//            ],
//          ),
//          Padding(
//            padding: EdgeInsets.only(top: 10),
//            child: Row(
//              children: <Widget>[
//                Column(children: <Widget>[
//                  Text(
//                    weatherBean != null
//                        ? weatherBean.HeWeather[0].aqi.city.aqi
//                        : "",
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 30,
//                        decoration: TextDecoration.none),
//                  ),
//                  Text(
//                    'AQI指数',
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 16,
//                        decoration: TextDecoration.none),
//                  )
//                ]),
//                Column(children: <Widget>[
//                  Text(
//                      weatherBean != null
//                          ? weatherBean.HeWeather[0].aqi.city.pm25
//                          : "",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 30,
//                          decoration: TextDecoration.none)),
//                  Text('PM2.5指数',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 16,
//                          decoration: TextDecoration.none))
//                ])
//              ],
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//            ),
//          )
//        ],
//      ),
//      decoration: BoxDecoration(color: Colors.black38),
//    );
//  }

  //生活建议
//  Widget _suggestionLayout() {
//    return Container(
//      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//      child: Column(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Text(
//                '生活建议',
//                style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 20,
//                    decoration: TextDecoration.none),
//              )
//            ],
//            mainAxisAlignment: MainAxisAlignment.start,
//          ),
//          _suggestContentLayout(weatherBean != null
//              ? weatherBean.HeWeather[0].suggestion.comf.txt
//              : ""),
//          _suggestContentLayout(weatherBean != null
//              ? weatherBean.HeWeather[0].suggestion.sport.txt
//              : ""),
//          _suggestContentLayout(weatherBean != null
//              ? weatherBean.HeWeather[0].suggestion.cw.txt
//              : ""),
//        ],
//      ),
//      decoration: BoxDecoration(color: Colors.black38),
//    );
//  }

  Widget _suggestContentLayout(String content) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        content,
        style: TextStyle(
            color: Colors.white, fontSize: 14, decoration: TextDecoration.none),
      ),
    );
  }

  Future<void> _queryWeather(double longitude, double latitude) async {
    String url = 'https://api.caiyunapp.com/v2/' +
        Global.caiYunKey +
        '/$longitude,$latitude/' +
        'weather.json?dailysteps=6';

    print(url);

    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        Map data = jsonDecode(json);
        setState(() {
          weatherBean = WeatherBean.fromJson(data);
          result = weatherBean.result;
          realtime = result.realtime;
          minutely = result.minutely;
          hourly = result.hourly;
          daily = result.daily;
          time = weatherBean.server_time.toString();
        });
      }
    } catch (ignore) {}
  }
}
