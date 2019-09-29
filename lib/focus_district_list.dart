import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bean/focus_district_list_bean.dart';
import 'global.dart';

class FocusDistrictList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FocusDistrictListState();
  }
}

class _FocusDistrictListState extends State<FocusDistrictList> {
  FocusDistrictListBean focusCountyListBean =
      FocusDistrictListBean(List<District>());

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    focusCountyListBean.districtList.clear();
    focusCountyListBean.districtList.add(Global.locationDistrict);

    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      String focusCountyListJson = prefs.getString('focus_district_data');
      if (focusCountyListJson != null) {
        FocusDistrictListBean bean =
            FocusDistrictListBean.fromJson(json.decode(focusCountyListJson));
        setState(() {
          focusCountyListBean.districtList.addAll(bean.districtList);
        });
      }
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
          title: Text('选择城市'),
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            focusCountyListBean != null
                ? Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: ListView.builder(
                        itemCount: focusCountyListBean.districtList.length,
                        itemBuilder: (BuildContext context, int position) {
                          District county = focusCountyListBean.districtList
                              .elementAt(position);
                          return getRow(county, position);
                        }),
                  )
                : Center(),
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
            onPressed: _selectDistrict, child: new Icon(Icons.add)));
  }

  Widget getRow(District county, int position) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15,
          position == focusCountyListBean.districtList.length - 1 ? 15 : 0),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
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
                                    image: AssetImage("image/location_ic.png"),
                                    width: 22,
                                    color: Colors.white60,
                                  ),
                                )
                              : Center(),
                          Text(county.name,
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text('22°晴',
                          style:
                              new TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              onTap: () {
                setState(() {
//              focusCountyListBean.districtList.remove(county);
//              Future<SharedPreferences> future = SharedPreferences
//                  .getInstance();
//              future.then((prefs) {
//                prefs.setString(
//                    'focus_district_data', jsonEncode(focusCountyListBean));
//              });
                });
              }),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('image/sunny.jpg'),
            fit: BoxFit.fitWidth,
          ))),
    );
  }
}
