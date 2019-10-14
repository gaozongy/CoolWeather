import 'package:coolweather/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingLayoutState();
  }
}

class _SettingLayoutState extends State<Setting> {
  bool isNotifyOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('设置'),
        elevation: 0,
      ),
      body: Consumer<UnitModel>(
        builder: (context, unitModel, _) => ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: _unitRowWidget(
                  '温度单位',
                  temperatureUnitList.elementAt(unitModel.temperature.index),
                  temperatureUnitList,
                  unitModel.setTemperatureUnit),
            ),
            _unitRowWidget('风力单位', windUnitList.elementAt(unitModel.wind.index),
                windUnitList, unitModel.setWindUnit),
            _unitRowWidget(
                '降水量',
                rainfallUnitList.elementAt(unitModel.rainfall.index),
                rainfallUnitList,
                unitModel.setRainfallUnit),
            _unitRowWidget(
              '能见度',
              visibilityUnitList.elementAt(unitModel.visibility.index),
              visibilityUnitList,
              unitModel.setVisibilityUnit,
            ),
            _unitRowWidget(
              '气压',
              airPressureUnitList.elementAt(unitModel.airPressure.index),
              airPressureUnitList,
              unitModel.setAirPressureUnit,
            ),
            _warnRowWidget(),
            _dividerLayout(),
            _aboutRowWidget(),
            _dividerLayout()
          ],
        ),
      ),
    );
  }

  Widget _unitRowWidget(
    String content,
    Unit unit,
    List<Unit> unitList,
    Function setUnit,
  ) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  content,
                  style: TextStyle(fontSize: 17),
                ),
                Text(unit.toString(),
                    style: TextStyle(fontSize: 12.5, color: Colors.grey)),
              ],
            ),
          ),
          _dividerLayout()
        ],
      ),
      onTap: () {
        selectUnit(content, unitList, setUnit);
      },
    );
  }

  Widget _warnRowWidget() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '天气预警',
                  style: TextStyle(fontSize: 17),
                ),
                Text('当出现特殊天气时通知提醒',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey))
              ],
            ),
          ),
          Switch(
            activeColor: Colors.blue,
            value: isNotifyOpen,
            onChanged: (value) {},
          ),
        ],
      ),
      onTap: () {
        setState(() {
          isNotifyOpen = !isNotifyOpen;
        });
      },
    );
  }

  Widget _aboutRowWidget() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Text(
          '关于',
          style: TextStyle(fontSize: 17),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed("about");
      },
    );
  }

  // 分割线
  Widget _dividerLayout() {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: Colors.grey[300],
    );
  }

  Future<void> selectUnit(
      String title, List<Unit> unitList, Function setUnit) async {
    int position = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal),
            ),
            children: getDialogOptionList(unitList),
          );
        });

    setUnit(position);
  }

  List<Widget> getDialogOptionList(List<Unit> unitList) {
    List<Widget> widgetList = List();
    for (int i = 0; i < unitList.length; i++) {
      widgetList.add(SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, i);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Text(
            unitList.elementAt(i).toString(),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ));
    }

    return widgetList;
  }
}
