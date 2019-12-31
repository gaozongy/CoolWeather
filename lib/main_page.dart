import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:amap_location/amap_location.dart';
import 'package:coolweather/bean/weather_bean.dart';
import 'package:coolweather/data/global.dart';
import 'package:coolweather/utils/image_utils.dart';
import 'package:coolweather/utils/translation_utils.dart';
import 'package:coolweather/views/weather/base_weather_state.dart';
import 'package:coolweather/views/weather/cloudy_anim.dart';
import 'package:coolweather/views/weather/cloudy_night_anim.dart';
import 'package:coolweather/views/weather/empty_bg.dart';
import 'package:coolweather/views/weather/haze_anim.dart';
import 'package:coolweather/views/weather/overcast_anim.dart';
import 'package:coolweather/views/weather/overcast_night_anim.dart';
import 'package:coolweather/views/weather/rain_anim.dart';
import 'package:coolweather/views/weather/snow_anim.dart';
import 'package:coolweather/views/weather/snow_night_anim.dart';
import 'package:coolweather/views/weather/sunny_anim.dart';
import 'package:coolweather/views/weather/sunny_night_anim.dart';
import 'package:device_info/device_info.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bean/focus_district_list_bean.dart';
import 'data/constant.dart';
import 'utils/date_utils.dart';
import 'utils/screen_utils.dart';
import 'weather_detail_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  /// 关注城市列表
  List<District> districtList = new List();

  int currentPage = 0;

  District district;

  WeatherBean weatherBean;

  PageController _pageController = new PageController();

  String updateTime = '努力加载中';

  double screenHeight;
  double statsHeight;
  double titleHeight = 50;
  double paddingTop = 10;

  bool needLocation = true;

  /// 用于局部刷新天气动画
  GlobalKey<BaseAnimState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _initPageController();
    _initData();
    _getDeviceTypeAndId();
  }

  _initPageController() {
    _pageController.addListener(() {
      int page = (_pageController.page + 0.5).toInt();
      if (page != currentPage) {
        setState(() {
          currentPage = page;
          district = districtList.elementAt(page);
          if (district.weatherBean != null) {
            updateWeatherState(weatherBean);
          }
        });
      }
      changeAnimAlpha(district.scrollProgress);
    });
  }

  _initData() async {
    districtList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Constant.spFocusDistrictData)) {
      String focusDistrictListJson =
          prefs.getString(Constant.spFocusDistrictData);
      if (focusDistrictListJson != null) {
        FocusDistrictListBean focusDistrictListBean =
            FocusDistrictListBean.fromJson(json.decode(focusDistrictListJson));
        if (focusDistrictListBean != null) {
          setState(() {
            districtList.addAll(focusDistrictListBean.districtList);
            if (currentPage == 0) {
              this.district = focusDistrictListBean.districtList.elementAt(0);
            }
          });

          districtList.forEach((district) {
            String weatherJson = prefs.getString(district.name);
            if (!isEmpty(weatherJson)) {
              Map map = jsonDecode(weatherJson);
              WeatherBean weatherBean = WeatherBean.fromJson(map);
              district.weatherBean = weatherBean;
            }
          });
        }
      }
    } else {
      District district = District("", "", '未知', -1, -1, isLocation: true);
      setState(() {
        districtList.add(district);
        this.district = district;
      });
      FocusDistrictListBean focusDistrictListBean =
          FocusDistrictListBean(districtList);
      prefs.setString(
          Constant.spFocusDistrictData, json.encode(focusDistrictListBean));
    }
  }

  _getDeviceTypeAndId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      Global.deviceType = Constant.androidDevice;
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Global.deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      Global.deviceType = Constant.iOSDevice;
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Global.deviceId = iosInfo.identifierForVendor;
    }
  }

  /// PageView 子页面通知主界面当前天气数据
  setWeatherData(District district, WeatherBean weatherBean) {
    // 当回调的城市信息和 PageView 当前页的城市是同一个，则直接更新天气数据
    // 否则从 _pageController 事件回调中获取天气数据
    if (district == this.district) {
      updateWeatherState(weatherBean);
    }
  }

  /// 更新当前界面显示的天气信息
  updateWeatherState(WeatherBean weatherBean) {
    setState(() {
      this.weatherBean = weatherBean;
      this.updateTime = DateUtils.getTimeDesc(weatherBean.server_time) + '更新';
    });
  }

  /// PageView 子页面回调方法
  setLocation(District district) {
    needLocation = false;
    List<District> list = List();
    list.add(district);
    districtList.replaceRange(0, 1, list);

    if (currentPage == 0) {
      setState(() {
        this.district = district;
      });
    }

    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      prefs.setString(Constant.spFocusDistrictData,
          json.encode(FocusDistrictListBean(districtList)));
    });
  }

  _focusDistrictList() {
    Navigator.of(context).pushNamed("focus_district_list").then((hasChanged) {
      if (hasChanged) {
        _initData();
      }
    });
  }

  /// 将天气信息生成卡片分享
  void _share() async {
    if (district != null &&
        district.latitude != -1 &&
        district.longitude != -1 &&
        weatherBean != null) {
      Share.file(
          district.name + '天气分享',
          district.name + DateUtils.getCurrentTimeMMDD() + '天气.png',
          await _createWeatherCard(),
          'image/png');
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
    bool isDay = DateUtils.isDay(weatherBean);

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

  @override
  Widget build(BuildContext context) {
    screenHeight = ScreenUtils.getScreenHeight(context);
    statsHeight = ScreenUtils.getSysStatsHeight(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: _createLayout(),
      ),
    );
  }

  Widget _createLayout() {
    List<Widget> layoutList = List();

    Widget weatherDetailWidget = Padding(
      padding: EdgeInsets.only(top: statsHeight + paddingTop + titleHeight),
      child: PageView.builder(
        controller: _pageController,
        itemCount: districtList.length,
        itemBuilder: (BuildContext context, int position) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              double scrollProgress = notification.metrics.pixels /
                  notification.metrics.maxScrollExtent;
              changeAnimAlpha(scrollProgress);
              district.scrollProgress = scrollProgress;
              return true;
            },
            child: WeatherDetailPage(
                districtList.elementAt(position),
                setLocation,
                setWeatherData,
                screenHeight -

                    /// ListView 内部自动加了一个 paddingTop，此 paddingTop 的值为 statsHeight
                    statsHeight * 2 -
                    paddingTop -
                    titleHeight,
                needLocation),
          );
        },
      ),
    );

    layoutList.add(_getWeatherAnimWidget());
    layoutList.add(weatherDetailWidget);
    layoutList.add(_titleWidget());

    Widget mainLayout = Stack(
      children: layoutList,
    );

    return mainLayout;
  }

  /// 修改天气动画透明度
  void changeAnimAlpha(double scrollProgress) {
    double progress = 1.0 - scrollProgress / 0.5;
    double alpha = progress >= 0 ? progress : 0;
    _globalKey.currentState.setMaskAlpha(alpha);
  }

  /// 根据天气类型获取天气动画
  Widget _getWeatherAnimWidget() {
    Widget animWidget;
    if (weatherBean == null) {
      animWidget = EmptyBg();
    } else {
      switch (weatherBean.result.realtime.skycon) {
        case 'CLEAR_DAY':
          animWidget = SunnyAnim(key: _globalKey);
          break;
        case 'CLEAR_NIGHT':
          animWidget = SunnyNightAnim(key: _globalKey);
          break;
        case 'PARTLY_CLOUDY_DAY':
          animWidget = CloudyAnim(key: _globalKey);
          break;
        case 'PARTLY_CLOUDY_NIGHT':
          animWidget = CloudyNightAnim(key: _globalKey);
          break;
        case 'CLOUDY':
          if (DateUtils.isDay(weatherBean)) {
            animWidget = OvercastAnim(key: _globalKey);
          } else {
            animWidget = OvercastNightAnim(key: _globalKey);
          }
          break;
        case 'RAIN':
          animWidget = RainAnim(
              weatherBean != null ? DateUtils.isDay(weatherBean) : true,
              key: _globalKey);
          break;
        case 'SNOW':
          if (weatherBean != null) {
            animWidget = DateUtils.isDay(weatherBean)
                ? SnowAnim(key: _globalKey)
                : SnowNightAnim(key: _globalKey);
          }
          break;
        case 'HAZE':
          animWidget = HazeAnim(
              weatherBean != null ? DateUtils.isDay(weatherBean) : true,
              key: _globalKey);
          break;
        default:
          animWidget = EmptyBg();
      }
    }

    return animWidget;
  }

  /// 顶部标题栏
  Widget _titleWidget() {
    return Padding(
      padding: EdgeInsets.only(top: statsHeight + paddingTop),
      child: SizedBox(
        height: titleHeight,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[_titleContentLayout(), _titleMenuIconLayout()],
        ),
      ),
    );
  }

  Widget _titleContentLayout() {
    return Row(
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
            : SizedBox(),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                district != null ? district.name : '正在定位',
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
    );
  }

  Widget _titleMenuIconLayout() {
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: Row(
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
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (position) {
              if (position == 0) {
                _share();
              } else if (position == 1) {
                Navigator.of(context).pushNamed("setting");
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem>[
                PopupMenuItem(
                  value: 0,
                  child: Text("分享"),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text("设置"),
                )
              ];
            },
          ),
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
