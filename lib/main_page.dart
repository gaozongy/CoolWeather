import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:amap_location/amap_location.dart';
import 'package:coolweather/bean/weather_bean.dart';
import 'package:coolweather/data/global.dart';
import 'package:coolweather/utils/share_utils.dart';
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

///  App 主界面
class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  OverlayEntry overlayEntry;

  /// 关注城市列表
  List<District> districtList = new List();

  /// PageView 当前页码
  int currentPage = 0;

  /// 当前显示的城市
  District district;

  /// 当前显示的天气
  WeatherBean weatherBean;

  PageController _pageController = new PageController();

  String updateTime = '努力加载中';

  /// 屏幕高度
  double screenHeight;

  /// 系统状态栏高度
  double statsHeight;

  /// title 栏高度
  double titleHeight = 70;

  /// 是否需要定位
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

  /// 初始化 PageView Controller
  _initPageController() {
    _pageController.addListener(() {
      int page = (_pageController.page + 0.5).toInt();
      if (page != currentPage) {
        setState(() {
          currentPage = page;
          district = districtList.elementAt(page);
          if (district.weatherBean != null) {
            updateWeatherState(district.weatherBean);
          }
        });
      }
      changeAnimAlpha(district.scrollProgress);
    });
  }

  /// 初始化数据
  _initData() async {
    districtList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Constant.spFocusDistrictData)) {
      districtList = queryDistrictList(prefs);
      if (currentPage == 0) {
        setState(() {
          this.district = districtList.elementAt(0);
        });
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

  /// 查询已关注城市列表及缓存的城市天气数据
  List<District> queryDistrictList(SharedPreferences prefs) {
    List<District> districtList = List();
    String focusDistrictListJson =
        prefs.getString(Constant.spFocusDistrictData);
    if (focusDistrictListJson != null) {
      FocusDistrictListBean focusDistrictListBean =
          FocusDistrictListBean.fromJson(json.decode(focusDistrictListJson));
      if (focusDistrictListBean != null) {
        districtList.addAll(focusDistrictListBean.districtList);
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
    return districtList;
  }

  /// 获取设备类型和设备 id
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

  /// 跳转警告信息页
  _warning() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
    Navigator.of(context).pushNamed("warning");
  }

  /// 跳转关注城市列表页
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
      String districtName = district.name;
      Share.file(
          districtName + '天气分享',
          districtName + DateUtils.getCurrentTimeMMDD() + '天气.png',
          await ShareUtils.createWeatherCard(districtName, weatherBean),
          'image/png');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = ScreenUtils.getScreenHeight(context);
    statsHeight = ScreenUtils.getSysStatsHeight(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _createLayout(),
      ),
    );
  }

  Widget _createLayout() {
    List<Widget> layoutList = List();

    Widget weatherDetailWidget = Padding(
      padding: EdgeInsets.only(top: statsHeight + titleHeight),
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
                    // ListView 内部自动加了一个 paddingTop，此 paddingTop 的值为 statsHeight
                    statsHeight * 2 -
                    titleHeight,
                needLocation),
          );
        },
      ),
    );

    layoutList.add(_createWeatherAnimWidget());
    layoutList.add(weatherDetailWidget);
    layoutList.add(_createTitleWidget());

    Widget mainLayout = Stack(
      children: layoutList,
    );

    return mainLayout;
  }

  /// 修改天气动画透明度
  void changeAnimAlpha(double scrollProgress) {
    double progress = 1.0 - scrollProgress / 0.3;
    double alpha = progress >= 0 ? progress : 0;
    if (_globalKey.currentState != null) {
      _globalKey.currentState.setMaskAlpha(alpha);
    }
  }

  /// 根据天气类型获取天气动画
  Widget _createWeatherAnimWidget() {
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
  Widget _createTitleWidget() {
    return Padding(
      padding: EdgeInsets.only(top: statsHeight),
      child: SizedBox(
        height: titleHeight,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_titleContentLayout(), _titleMenuIconLayout()],
        ),
      ),
    );
  }

  /// 标题栏布局
  Widget _titleContentLayout() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        currentPage == 0
            ? Padding(
                padding: EdgeInsets.only(left: 22),
                child: ImageIcon(
                  AssetImage("images/ic_location.png"),
                  size: 22,
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

  /// 标题栏右侧菜单布局
  Widget _titleMenuIconLayout() {
    List<Widget> menuList = List();
//    if(weatherBean.result.realtime.) {
//    menuList.add(IconButton(
//      icon: ImageIcon(
//        AssetImage("images/ic_warning.png"),
//        size: 20,
//        color: Colors.white,
//      ),
//      onPressed: _warning,
//    ));
//    }
    menuList.add(IconButton(
      icon: ImageIcon(
        AssetImage("images/ic_building.png"),
        size: 20,
        color: Colors.white,
      ),
      onPressed: _focusDistrictList,
    ));
    menuList.add(PopupMenuButton(
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
    ));
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: menuList,
      ),
    );
  }

  @override
  void dispose() {
    AMapLocationClient.shutdown();
    super.dispose();
  }
}
