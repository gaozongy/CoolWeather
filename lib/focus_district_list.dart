import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bean/focus_district_list_bean.dart';

class FocusDistrictList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FocusDistrictListState();
  }
}

class _FocusDistrictListState extends State<FocusDistrictList> {
  FocusDistrictListBean focusCountyListBean;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      String focusCountyListJson = prefs.getString('focus_district_data');
      if (focusCountyListJson != null) {
        FocusDistrictListBean bean =
            FocusDistrictListBean.fromJson(json.decode(focusCountyListJson));
        setState(() {
          focusCountyListBean = bean;
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
        body: focusCountyListBean != null
            ? ListView.builder(
                itemCount: focusCountyListBean.districtList.length,
                itemBuilder: (BuildContext context, int position) {
                  District county =
                      focusCountyListBean.districtList.elementAt(position);
                  return getRow(county);
                })
            : Center(),
        floatingActionButton: FloatingActionButton(
            onPressed: _selectDistrict, child: new Icon(Icons.add)));
  }

  Widget getRow(District county) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
          child: InkWell(
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(county.name,
                      style: new TextStyle(color: Colors.white, fontSize: 16)),
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
