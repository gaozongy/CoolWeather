import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingLayoutState();
  }
}

class _SettingLayoutState extends State<Setting> {
  bool isNotifyOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('设置'),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: _unitRowWidget('温度单位', '℃ - 摄氏度'),
          ),
          _unitRowWidget('风力单位', 'km/h - 千米/小时'),
          _unitRowWidget('降水量', 'mm - 毫米'),
          _unitRowWidget('能见度', 'km - 千米'),
          _unitRowWidget('气压', 'hPa - 百帕'),
          _warnRowWidget(),
          _dividerLayout(),
          _aboutRowWidget(),
          _dividerLayout()
        ],
      ),
    );
  }

  Widget _unitRowWidget(String key, String value) {
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
      onTap: () {},
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
}
