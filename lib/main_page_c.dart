import 'package:coolweather/bean/weather_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'bean/focus_district_list_bean.dart';
import 'data/global.dart';
import 'utils/screen_utils.dart';

class MainPageC extends StatefulWidget {
  MainPageC({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageCState();
  }
}

class MainPageCState extends State<MainPageC> {
  List<District> districtList = new List();

  int currentPage = 0;

  District district;

  WeatherBean weatherBean;

  PageController _pageController = new PageController();

  double screenHeight;
  double statsHeight;

  @override
  void initState() {
    super.initState();

    district = Global.locationDistrict;
    districtList.add(Global.locationDistrict);

    _initPageController();
  }

  _initPageController() {
    _pageController.addListener(() {
      int page = (_pageController.page + 0.5).toInt();
      if (page != currentPage) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = ScreenUtils.getScreenHeight(context);
    statsHeight = ScreenUtils.getSysStatsHeight(context);

    print('screenHeight：$screenHeight');

    print('statsHeight: $statsHeight');

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: 5,
        itemBuilder: (BuildContext context, int position) {
          return ListView(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(color: Colors.blue),
              ),
              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int position) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(position.toString()),
                    );
                  })
            ],
          );
        },
      ),
    );
  }
}
