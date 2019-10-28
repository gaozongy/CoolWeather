import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:amap_location/amap_location.dart';
import 'package:coolweather/bean/weather_bean.dart';
import 'package:coolweather/utils/image_utils.dart';
import 'package:coolweather/utils/translation_utils.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bean/focus_district_list_bean.dart';
import 'data/global.dart';
import 'utils/date_utils.dart';
import 'utils/screen_utils.dart';
import 'views/popup_window_button.dart';
import 'weather_detail_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  List<District> districtList = new List();

  int currentPage = 0;

  District district;

  WeatherBean weatherBean;

  PageController _pageController = new PageController();

  String updateTime = '未知';

  double screenHeight;
  double statsHeight;
  double titleHeight = 50;
  double paddingTop = 10;

  GlobalKey rootWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    district = Global.locationDistrict;
    districtList.add(Global.locationDistrict);

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
        setState(() {
          districtList.removeRange(1, districtList.length);
          if (focusDistrictListBean != null) {
            districtList.addAll(focusDistrictListBean.districtList);
          }
        });
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

  void _share() async {
    if (district != null &&
        district.latitude != -1 &&
        district.longitude != -1 &&
        weatherBean != null) {
      Share.file(
              district.name + '天气分享',
              district.name + DateUtils.getCurrentTimeMMDD() + '天气.png',
              await _createWeatherCard(),
              'image/png')
          .then((value) {
        print('gaozy: share end');
      });
    }
  }

  Future<Uint8List> _createWeatherCard() async {
    PictureRecorder recorder = new PictureRecorder();

    Canvas canvas = new Canvas(recorder);

    Result result = weatherBean.result;
    // 天气描述
    String weather = result.realtime.skycon;
    // 降雨（雪）强度
    double intensity = result.realtime.precipitation.local.intensity;
    // 是否是白天
    DateTime date = DateTime.now();
    String currentDate =
        "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ";
    DateTime sunriseDate = DateTime.parse(
        currentDate + result.daily.astro.elementAt(0).sunrise.time);
    DateTime sunsetDate = DateTime.parse(
        currentDate + result.daily.astro.elementAt(0).sunset.time);
    bool isDay = DateUtils.isDay(sunriseDate, sunsetDate);

    // 背景图片
    final ByteData bgByteData = await rootBundle
        .load(ImageUtils.getWeatherShareBgUri(weather, intensity, isDay));
    if (bgByteData == null) throw 'Unable to read data';
    var codec = await instantiateImageCodec(bgByteData.buffer.asUint8List());
    FrameInfo frame = await codec.getNextFrame();
    canvas.drawImage(frame.image, new Offset(0, 0), new Paint());

    TextPainter districtTp = getTextPainter(district.name, 45,
        fontWeight: FontWeight.w600,
        text2: '    ' + DateUtils.getCurrentTimeMMDD(),
        fontSize2: 35);
    districtTp.paint(canvas, Offset(50, 40));

    TextPainter temperatureTp = getTextPainter(
      weatherBean.result.realtime.temperature.toStringAsFixed(0) + "°",
      140,
      fontWeight: FontWeight.w300,
    );
    temperatureTp.paint(canvas, Offset(50, 180));

    TextPainter weatherTp = getTextPainter(
        Translation.getWeatherDesc(weatherBean.result.realtime.skycon,
                weatherBean.result.realtime.precipitation.local.intensity) +
            '  ' +
            weatherBean.result.daily.temperature
                .elementAt(0)
                .max
                .toStringAsFixed(0) +
            ' / ' +
            weatherBean.result.daily.temperature
                .elementAt(0)
                .min
                .toStringAsFixed(0) +
            '℃',
        45);
    weatherTp.paint(canvas, Offset(50, 350));

    Picture picture = recorder.endRecording();
    ByteData byteData = await (await picture.toImage(1038, 450))
        .toByteData(format: ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  TextPainter getTextPainter(
    String text,
    double fontSize, {
    FontWeight fontWeight,
    String text2,
    double fontSize2,
  }) {
    return TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(children: [
        TextSpan(
          text: text,
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight != null ? fontWeight : FontWeight.w400),
        ),
        TextSpan(
          text: text2,
          style: TextStyle(
            color: Colors.white70,
            fontSize: fontSize2,
          ),
        )
      ]),
    )..layout();
  }

  _setting() {
    Navigator.of(context).pushNamed("setting");
  }

  setLocationWeather(WeatherBean weatherBean) {
    this.weatherBean = weatherBean;
    setState(() {
      updateTime = DateUtils.getTimeDesc(weatherBean.server_time) + '更新';
    });
  }

  setLocation(District district) {
    List<District> list = List();
    list.add(district);
    districtList.replaceRange(0, 1, list);

    if (currentPage == 0) {
      setState(() {
        this.district = district;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = ScreenUtils.getScreenHeight(context);
    statsHeight = ScreenUtils.getSysStatsHeight(context);

    ScreenUtils.pxToLogicalPixels(context, 10);

    print('screenHeight：$screenHeight');

    print('statsHeight: $statsHeight');

    return Scaffold(
      body: Container(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: statsHeight + paddingTop + titleHeight),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: districtList.length,
                  itemBuilder: (BuildContext context, int position) {
                    return WeatherDetailPage(
                        districtList.elementAt(position),
                        setLocation,
                        setLocationWeather,
                        screenHeight -

                            /// ListView 内部自动加了一个 paddingTop，此 paddingTop 的值为 statsHeight
                            statsHeight * 2 -
                            paddingTop -
                            titleHeight);
                  },
                ),
              ),
              _titleLayout(),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/bg_main.png'),
            fit: BoxFit.fitHeight,
          ))),
    );
  }

  Widget _titleLayout() {
    return Padding(
      padding: EdgeInsets.only(top: statsHeight + paddingTop),
      child: SizedBox(
        height: titleHeight,
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
                          image: AssetImage("images/ic_location.png"),
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
                        district.name,
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
              children: <Widget>[
                IconButton(
                  icon: Image(
                    image: AssetImage("images/ic_building.png"),
                    width: 20,
                    height: 20,
                  ),
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
                        size: 25,
                      ),
                      window: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 60, 15),
                              child: Text(
                                '分享',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            onTap: _share,
                          ),
                          InkWell(
                            child: Padding(
                              child: Text(
                                '设置',
                                style: TextStyle(fontSize: 16),
                              ),
                              padding: EdgeInsets.fromLTRB(15, 15, 60, 15),
                            ),
                            onTap: _setting,
                          ),
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
