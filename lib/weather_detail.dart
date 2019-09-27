import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amap_location/amap_location.dart';

import 'bean/daily.dart';
import 'bean/focus_district_list_bean.dart';
import 'bean/hourly.dart';
import 'bean/minutely.dart';
import 'bean/realtime.dart';
import 'bean/weather_bean.dart';
import 'global.dart';
import 'utils/date_utils.dart';
import 'utils/translation_utils.dart';
import 'views/popup_window_button.dart';
import 'views/precipitation_line.dart';
import 'views/sunrise_sunset_widget.dart';
import 'views/temp_line.dart';
import 'utils/screen_utils.dart';

class WeatherDetail extends StatefulWidget {
  WeatherDetail({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainLayoutState();
  }
}

class _MainLayoutState extends State<WeatherDetail> {
  List<District> districtList = new List();

  int currentPage = 0;

  District district;

  PageController _pageController = new PageController();

  /// 是否已取得定位
  bool position = false;

  String updateTime = '未知';

  double statsHeight;

  @override
  void initState() {
    super.initState();

    district = District('未知', 0, 0);
    districtList.add(district);

    _initPageController();
    _initData();
  }

  _initPageController() {
    _pageController.addListener(() {
      int page = (_pageController.page + 0.5).toInt();
      if (page != currentPage) {
        setState(() {
          currentPage = page;
          district = districtList.elementAt(page);
        });
      }
    });
  }

  _initData() {
    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      String focusDistrictListJson = prefs.getString('focus_district_data');
      if (focusDistrictListJson != null) {
        FocusDistrictListBean focusDistrictListBean =
            FocusDistrictListBean.fromJson(json.decode(focusDistrictListJson));
        if (focusDistrictListBean != null &&
            focusDistrictListBean.districtList.length > 0) {
          setState(() {
            districtList.addAll(focusDistrictListBean.districtList);
          });
          return;
        }
      }
    });
  }

  _focusDistrictList() {
    Navigator.of(context).pushNamed("focus_district_list").then((bool) {
      if (bool) {
        _initData();
      }
    });
  }

  setUpdateTime(int time) {
    setState(() {
      updateTime = DateUtils.getTimeDesc(time) + '更新';
    });
  }

  setLocation(District c) {
    List<District> list = List();
    list.add(c);
    districtList.replaceRange(0, 1, list);

    if (currentPage == 0) {
      setState(() {
        district = c;
      });
    }

    position = true;
  }

  @override
  Widget build(BuildContext context) {
    statsHeight = ScreenUtils.getSysStatsHeight(context);

    print('statsHeight: $statsHeight');

    return Scaffold(
      body: Container(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50 + statsHeight + 10),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: districtList.length,
                  itemBuilder: (BuildContext context, int position) {
                    return _WeatherDetailWidget(
                        districtList.elementAt(position),
                        setUpdateTime,
                        setLocation);
                  },
                ),
              ),
              _titleLayout(),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('image/main_bg_2.png'),
            fit: BoxFit.fitHeight,
          ))),
    );
  }

  Widget _titleLayout() {
    return Padding(
      padding: EdgeInsets.only(top: statsHeight + 10),
      child: SizedBox(
        height: 50,
        width: double.infinity,
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
                        district != null ? district.name : '未知',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        updateTime,
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
                  onPressed: _focusDistrictList,
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
  final District district;

  final Function setUpdateTime;

  final Function setLocation;

  _WeatherDetailWidget(this.district, this.setUpdateTime, this.setLocation);

  @override
  State<StatefulWidget> createState() {
    return _WeatherDetailState(district);
  }
}

class _WeatherDetailState extends State<_WeatherDetailWidget> {
  District district;

  WeatherBean weatherBean;

  Result result;

  Realtime realtime;

  Minutely minutely;

  Hourly hourly;

  Daily daily;

  _WeatherDetailState(this.district);

  @override
  void initState() {
    super.initState();

    if (district.latitude == 0 && district.longitude == 0) {
      _initLocation();
    } else {
      _queryWeather(district.longitude, district.latitude);
    }
  }

  // 定位
  _initLocation() async {
    bool result = await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));

    if (result) {
      AMapLocation aMapLocation = await AMapLocationClient.getLocation(true);
      if (aMapLocation.district == null ||
          aMapLocation.latitude == null ||
          aMapLocation.longitude == null) {
        return;
      }

      district = new District(
          aMapLocation.district, aMapLocation.latitude, aMapLocation.longitude);
      widget.setLocation(district);
      _queryWeather(district.longitude, district.latitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return weatherDetailLayout(context);
  }

  Widget weatherDetailLayout(BuildContext context) {
    print('屏幕高度：${ScreenUtils.getScreenHeight(context)}');
    // 一加5 1080 / 731.4285714285714 = 1.4765625
    // 红米note2 1080 / 640.0 = 1.6875
    if (weatherBean != null) {
      return RefreshIndicator(
        onRefresh: () => _queryWeather(district.longitude, district.latitude),
        child: ListView(
          children: <Widget>[
            _tempLayout(),
            _weatherLayout(),
            _tipsLayout(),
            _rainTendencyLayout(),
            _forecastLayout(),
            _tempLineLayout(),
            _dividerLayout(),
            _sunriseSunsetLayout(),
            _dividerLayout(),
            _moreInfLayout(),
          ],
        ),
      );
    } else {
      return Center();
    }
  }

  Widget _tempLayout() {
    return Padding(
      padding: EdgeInsets.only(left: 28, top: 370),
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

  Widget _tipsLayout() {
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

  Widget _rainTendencyLayout() {
    bool rain = false;
    minutely.probability.forEach((rainfall) {
      if (rainfall > 0) {
        rain = true;
      }
    });

    return rain
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: PrecipitationLineWidget(minutely.precipitation_2h),
          )
        : Center();
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

  // 气温折线图
  Widget _tempLineLayout() {
    List<Temp> tempList = List();

    var forecast = daily.temperature;
    for (int i = 0; i < forecast.length; i++) {
      tempList.add(Temp(forecast.elementAt(i).max, forecast.elementAt(i).min));
    }
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 20),
      child: TempLineWidget(tempList),
    );
  }

  // 日出日落
  Widget _sunriseSunsetLayout() {
    return SunriseSunsetWidget();
  }

  //  更多信息
  Widget _moreInfLayout() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Row(
                  children: <Widget>[
                    getWidget('空气质量', Translation.getAqiDesc(realtime.aqi), ''),
                    getWidget('PM2.5', realtime.pm25.toString(), ''),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Row(
                  children: <Widget>[
                    getWidget(Translation.getWindDir(realtime.wind.direction),
                        realtime.wind.speed.toString(), 'km/h'),
                    getWidget('体感温度',
                        realtime.temperature.toInt().toString() + '°', ''),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Row(
                  children: <Widget>[
                    getWidget(
                        '湿度',
                        (realtime.humidity * 100 + 0.5).toInt().toString(),
                        '%'),
                    getWidget('能见度', realtime.visibility.toString(), 'km'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Row(
                  children: <Widget>[
                    getWidget('紫外线', realtime.ultraviolet.desc, ''),
                    getWidget('气压', (realtime.pres ~/ 100).toString(), 'hPa'),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getWidget(String title, String value, String unit) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  decoration: TextDecoration.none)),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none)),
                Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(unit,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          decoration: TextDecoration.none)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 分割线
  Widget _dividerLayout() {
    return Divider(
      thickness: 1,
      color: Colors.white12,
    );
  }

  // 查询天气信息
  Future<void> _queryWeather(double longitude, double latitude) async {
    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) async {
      String json = prefs.getString(district.name);
      WeatherBean bean;
      if (!isEmpty(json)) {
        Map map = jsonDecode(json);
        bean = WeatherBean.fromJson(map);
        if (DateUtils.currentTimeMillis() - bean.server_time * 1000 >
            1000 * 60 * 15) {
          bean = null;
        }
      }

      if (bean == null) {
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
            json = await response.transform(utf8.decoder).join();
            Map map = jsonDecode(json);
            bean = WeatherBean.fromJson(map);

            future.then((prefs) {
              prefs.setString(district.name, json);
            });
          }
        } catch (ignore) {}
      }

      setState(() {
        weatherBean = bean;
        result = weatherBean.result;
        realtime = result.realtime;
        minutely = result.minutely;
        hourly = result.hourly;
        daily = result.daily;
        widget.setUpdateTime(weatherBean.server_time);
      });
    });
  }
}
