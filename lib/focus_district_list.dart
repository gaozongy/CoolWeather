import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bean/focus_district_list_bean.dart';
import 'bean/weather_bean.dart';
import 'global.dart';
import 'utils/translation_utils.dart';

class FocusDistrictList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FocusDistrictListState();
  }
}

class _FocusDistrictListState extends State<FocusDistrictList> {
  List<District> dataList = List();

  List<DistrictWeather> districtList = List();

  bool isEditMode = false;

  List<int> selectedPos = List();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    dataList.clear();
    districtList.clear();

    dataList.add(Global.locationDistrict);

    List<DistrictWeather> resultList = List();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String focusDistrictListJson = prefs.getString('focus_district_data');
    if (focusDistrictListJson != null) {
      FocusDistrictListBean bean =
          FocusDistrictListBean.fromJson(json.decode(focusDistrictListJson));
      dataList.addAll(bean.districtList);
    }

    dataList.forEach((district) {
      String json = prefs.getString(district.name);
      if (!isEmpty(json)) {
        Map map = jsonDecode(json);
        WeatherBean bean = WeatherBean.fromJson(map);
        resultList.add(DistrictWeather(district, bean.result.realtime));
      } else {
        resultList.add(DistrictWeather(district, null));
      }
    });

    setState(() {
      districtList.addAll(resultList);
    });
  }

  void _selectDistrict() {
    Navigator.of(context).pushNamed("select_district").then((bool) {
      if (bool) {
        _initData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          title: Text(isEditMode ? selectedPos.length.toString() : '选择城市'),
          leading: IconButton(
            icon: Icon(isEditMode ? Icons.close : Icons.arrow_back),
            onPressed: () {
              if (isEditMode) {
                setState(() {
                  isEditMode = false;
                  selectedPos.clear();
                });
              } else {}
            },
          ),
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: ListView.builder(
                  itemCount: districtList.length,
                  itemBuilder: (BuildContext context, int position) {
                    DistrictWeather district = districtList.elementAt(position);
                    return districtItem(district, position);
                  }),
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '天气数据来源于彩云天气网',
                    style: TextStyle(color: Colors.grey[400], fontSize: 10),
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _selectDistrict, child: Icon(Icons.add)));
  }

  Widget districtItem(DistrictWeather districtWeather, int position) {
    return Card(
      margin: EdgeInsets.fromLTRB(
          18, 15, 18, position == districtList.length - 1 ? 15 : 0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
          child: InkWell(
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        position == 0
                            ? Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Image(
                                  image: AssetImage("images/location_ic.png"),
                                  width: 22,
                                  color: Colors.white60,
                                ),
                              )
                            : Center(),
                        Text(districtWeather.district.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Text(
                        districtWeather.realtime != null
                            ? '${(districtWeather.realtime.temperature + 0.5).toInt()}°${Translation.getWeatherDesc(districtWeather.realtime.skycon)}'
                            : '',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
            onTap: () {
              if (isEditMode) {
                setState(() {
                  if (!selectedPos.contains(position)) {
                    selectedPos.add(position);
                  } else {
                    selectedPos.remove(position);
                    if (selectedPos.length == 0) {
                      isEditMode = false;
                    }
                  }
                });
              }
            },
            onLongPress: () {
              if (!isEditMode) {
                selectedPos.add(position);
                setState(() {
                  isEditMode = true;
                });
              }
            },
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/sunny.jpg'),
            fit: BoxFit.fitWidth,
          ))),
    );
  }
}
