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

  List<Unit> temperatureUnitList = [Unit('℃ - 摄氏度'), Unit('℉ - 华氏度')];

  List<Unit> windUnitList = [
    Unit('m/s - 米/秒'),
    Unit('km/h - 千米/小时'),
    Unit('ft/s - 英尺/秒'),
    Unit('mph - 英里/小时'),
    Unit('kts - 海里/小时')
  ];

  List<Unit> rainfallUnitList = [
    Unit('mm - 毫米'),
    Unit('in - 英寸'),
  ];

  List<Unit> visibilityUnitList = [
    Unit('km - 千米'),
    Unit('mi - 英里'),
  ];

  List<Unit> airPressureUnitList = [
    Unit('hPa - 百帕'),
    Unit('mmHg - 毫米汞柱'),
    Unit('inHg - 英寸汞柱'),
  ];

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
                  '温度单位', unitModel.temperature.toString(), unitModel, 0),
            ),
            _unitRowWidget('风力单位', unitModel.wind.toString(), unitModel, 1),
            _unitRowWidget('降水量', unitModel.rainfall.toString(), unitModel, 2),
            _unitRowWidget(
                '能见度', unitModel.visibility.toString(), unitModel, 3),
            _unitRowWidget(
                '气压', unitModel.airPressure.toString(), unitModel, 4),
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
      String key, String value, UnitModel unitModel, int type) {
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
                  key,
                  style: TextStyle(fontSize: 17),
                ),
                Text(value,
                    style: TextStyle(fontSize: 12.5, color: Colors.grey)),
              ],
            ),
          ),
          _dividerLayout()
        ],
      ),
      onTap: () {
        changeUnit(unitModel, type);
      },
    );
  }

  Widget _warnRowWidget() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        child: Text(
          '关于',
          style: TextStyle(fontSize: 17),
        ),
      ),
      onTap: () {},
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

  Future<void> changeUnit(UnitModel unitModel, int type) async {
    int position = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(type.toString()),
            children: getDialogOptionList(type),
          );
        });

    if (type == 0) {
      unitModel.setTemperatureUnit(TemperatureUnit.values[position]);
    }
  }

  List<Widget> getDialogOptionList(int type) {
    List<Widget> widgetList = List();
    if (type == 0) {
      for (int i = 0; i < temperatureUnitList.length; i++) {
        widgetList.add(SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, i);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(temperatureUnitList.elementAt(i).unit),
          ),
        ));
      }
    }

    return widgetList;
  }
}
