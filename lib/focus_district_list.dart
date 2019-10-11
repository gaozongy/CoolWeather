import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  /// 关注的城市列表是否有更改
  bool hasChanged = false;

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
        hasChanged = true;
      }
    });
  }

  void _deleteDistrict() async {
    List<District> temp = dataList;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 从大到小排序，便于对List执行删除操作
    selectedPos.sort((a, b) => a < b ? 1 : -1);
    selectedPos.forEach((pos) {
      District district = temp.elementAt(pos);
      prefs.remove(district.name);
      temp.removeAt(pos);
    });
    FocusDistrictListBean focusDistrictListBean =
        FocusDistrictListBean(temp.sublist(1));
    String focusCountyJson = jsonEncode(focusDistrictListBean.toJson());
    prefs.setString('focus_district_data', focusCountyJson);
    closeEditMode();
    _initData();
    hasChanged = true;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actionButtons = isEditMode
        ? [
            IconButton(
                icon: Icon(Icons.delete_outline), onPressed: _deleteDistrict)
          ]
        : List();

    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 1,
              title: Text(isEditMode ? selectedPos.length.toString() : '选择城市'),
              leading: IconButton(
                icon: Icon(isEditMode ? Icons.close : Icons.arrow_back),
                onPressed: () {
                  if (isEditMode) {
                    closeEditMode();
                  } else {
                    Navigator.pop(context, hasChanged);
                  }
                },
              ),
              actions: actionButtons,
            ),
            body: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: ListView.builder(
                      itemCount: districtList.length,
                      itemBuilder: (BuildContext context, int position) {
                        DistrictWeather district =
                            districtList.elementAt(position);
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
                onPressed: _selectDistrict, child: Icon(Icons.add))),
        onWillPop: () async {
          if (isEditMode) {
            closeEditMode();
            return false;
          } else {
            Navigator.pop(context, hasChanged);
            return false;
          }
        });
  }

  void closeEditMode() {
    setState(() {
      isEditMode = false;
      selectedPos.clear();
    });
  }

  Widget districtItem(DistrictWeather districtWeather, int position) {
    bool selected = isEditMode ? selectedPos.contains(position) : false;

    return Card(
      margin: EdgeInsets.fromLTRB(
          18, 16, 18, position == districtList.length - 1 ? 15 : 0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
        child: InkWell(
          child: SizedBox(
            height: 130,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            if (position == 0) {
              deleteInhibitToast();
              return;
            }
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
            if (position == 0) {
              deleteInhibitToast();
              return;
            }
            if (!isEditMode) {
              selectedPos.add(position);
              setState(() {
                isEditMode = true;
              });
            }
          },
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
                color: selected ? Colors.blue : Colors.transparent, width: 2),
            image: DecorationImage(
                image: AssetImage('images/sunny.jpg'),
                fit: BoxFit.fitWidth,
                colorFilter: selected
                    ? ColorFilter.mode(Colors.white54, BlendMode.hardLight)
                    : ColorFilter.mode(Colors.transparent, BlendMode.color))),
      ),
    );
  }

  void deleteInhibitToast() {
    Fluttertoast.showToast(
      msg: "当前定位不可删除哦～",
    );
  }
}
