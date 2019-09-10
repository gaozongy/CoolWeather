import 'dart:convert';
import 'dart:io';

import 'package:coolweather/bean/focus_county_list_bean.dart';
import 'package:coolweather/bean/weather_bean.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherDetail extends StatefulWidget {
  WeatherDetail({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainLayoutState();
  }
}

class _MainLayoutState extends State<WeatherDetail> {
  String bingImgUrl = '';

  List<County> countyList;

  int currentPage = 0;

  County county;

  PageController _pageController = new PageController();

  @override
  void initState() {
    super.initState();

    _queryImage();
    _initData();

    _pageController.addListener(() {
      int page = _pageController.page.toInt();
      print('page:' + '$page' + '  currentPage:' + '$currentPage');
      if (page != currentPage) {
        currentPage = page;
        setState(() {
          county = countyList.elementAt(page);
        });
      }
    });
  }

  _queryImage() async {
    String bingPicUrl = "http://guolin.tech/api/bing_pic";
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(bingPicUrl));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var imgUrl = await response.transform(utf8.decoder).join();
        setState(() {
          bingImgUrl = imgUrl;
        });
      }
    } catch (ignore) {}
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
            countyList = focusCountyListBean.countyList;
            county = countyList.elementAt(0);
          });
          return;
        }
      }

      _focusCountyList();
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
              countyList != null
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
                  : Text('empty'),
              _titleLayout(),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(bingImgUrl),
            fit: BoxFit.fitHeight,
          ))),
    );
  }

  Widget _titleLayout() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  county != null ? county.countyName : "未知",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  '10分钟之前更新',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    decoration: TextDecoration.none,
                  ),
                )
              ],
            ),
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
              IconButton(
                icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}

class _WeatherDetailWidget extends StatefulWidget {
  final County county;

  _WeatherDetailWidget(this.county);

  @override
  State<StatefulWidget> createState() {
    return _WeatherDetailState(county.countyName, county.weatherId);
  }
}

class _WeatherDetailState extends State<_WeatherDetailWidget> {
  String countyName;

  String weatherId;

  WeatherBean weatherMode;

  _WeatherDetailState(this.countyName, this.weatherId);

  @override
  void initState() {
    super.initState();

    _queryWeather();
  }

  _focusCountyList() {
    Navigator.of(context).pushNamed("focus_county_list").then((bool) {
      if (bool) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return weatherDetailLayout(context);
  }

  Widget weatherDetailLayout(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _queryWeather,
      child: ListView(
        children: <Widget>[
          _tempLayout(),
          _weatherLayout(),
          _from(),
          _forecastLayout(),
          _aqiLayout(),
          _suggestionLayout(),
        ],
      ),
    );
  }

  Widget _tempLayout() {
    return Padding(
      padding: EdgeInsets.fromLTRB(28, 350, 28, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            (weatherMode != null ? weatherMode.HeWeather[0].now.tmp : "0") +
                "°",
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
            weatherMode != null ? weatherMode.HeWeather[0].now.cond_txt : "未知",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }

  Widget _from() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "中国天气网",
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
    return Container(
      margin: EdgeInsets.fromLTRB(16, 15, 16, 0),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("预报",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      decoration: TextDecoration.none))
            ],
          ),
          _getForecastRow()
        ],
      ),
      decoration: BoxDecoration(color: Colors.black38),
    );
  }

  Widget _getForecastRow() {
    List<Widget> forecastRow = new List();
    for (int i = 0;
        weatherMode != null &&
            i < weatherMode.HeWeather[0].daily_forecast.length;
        i++) {
      Daily daily = weatherMode.HeWeather[0].daily_forecast.elementAt(i);
      forecastRow.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            _textLayout(daily.date),
            _textLayout(daily.cond.txt_d),
            _textLayout(daily.tmp.max),
            _textLayout(daily.tmp.min),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ));
    }

    return Column(
      children: forecastRow,
    );
  }

  Widget _textLayout(String content) {
    return Text(content,
        style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            decoration: TextDecoration.none));
  }

  Widget _aqiLayout() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("空气质量",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      decoration: TextDecoration.none))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Column(children: <Widget>[
                  Text(
                    weatherMode != null
                        ? weatherMode.HeWeather[0].aqi.city.aqi
                        : "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        decoration: TextDecoration.none),
                  ),
                  Text(
                    'AQI指数',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none),
                  )
                ]),
                Column(children: <Widget>[
                  Text(
                      weatherMode != null
                          ? weatherMode.HeWeather[0].aqi.city.pm25
                          : "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          decoration: TextDecoration.none)),
                  Text('PM2.5指数',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.none))
                ])
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(color: Colors.black38),
    );
  }

  Widget _suggestionLayout() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '生活建议',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    decoration: TextDecoration.none),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          _suggestContentLayout(weatherMode != null
              ? weatherMode.HeWeather[0].suggestion.comf.txt
              : ""),
          _suggestContentLayout(weatherMode != null
              ? weatherMode.HeWeather[0].suggestion.sport.txt
              : ""),
          _suggestContentLayout(weatherMode != null
              ? weatherMode.HeWeather[0].suggestion.cw.txt
              : ""),
        ],
      ),
      decoration: BoxDecoration(color: Colors.black38),
    );
  }

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

  Future<Null> _queryWeather() async {
    var url = 'http://guolin.tech/api/weather?cityid=' +
        '$weatherId' +
        '&key=bc0418b57b2d4918819d3974ac1285d9';

    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        Map data = jsonDecode(json);
        setState(() {
          weatherMode = new WeatherBean.fromJson(data);
        });
      }
    } catch (ignore) {}
  }
}
