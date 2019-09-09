import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bean/focus_county_list_bean.dart';

class FocusCountyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FocusCountyListState();
  }
}

class _FocusCountyListState extends State<FocusCountyList> {
  FocusCountyListBean focusCountyListBean;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      String focusCountyListJson = prefs.getString('focus_county_data');
      if (focusCountyListJson != null) {
        FocusCountyListBean bean =
            FocusCountyListBean.fromJson(json.decode(focusCountyListJson));
        setState(() {
          focusCountyListBean = bean;
        });
      }
    });
  }

  void _selectCounty() {
    Navigator.of(context).pushNamed("select_county").then((bool) {
      if (bool) {
        _initData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('选择城市'),
        ),
        body: focusCountyListBean != null
            ? ListView.builder(
                itemCount: focusCountyListBean.countyList.length,
                itemBuilder: (BuildContext context, int position) {
                  County county =
                      focusCountyListBean.countyList.elementAt(position);
                  return getRow(county);
                })
            : Text('empty'),
        floatingActionButton: FloatingActionButton(
            onPressed: _selectCounty, child: new Icon(Icons.add)));
  }

  Widget getRow(County county) {
    return new InkWell(
      child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: new Text(county.countyName, style: new TextStyle(fontSize: 16)),
      ),
      onTap: () {
        setState(() {
          focusCountyListBean.countyList.remove(county);
          Future<SharedPreferences> future = SharedPreferences.getInstance();
          future.then((prefs) {
            prefs.setString(
                'focus_county_data', jsonEncode(focusCountyListBean));
          });
        });
      },
    );
  }
}
