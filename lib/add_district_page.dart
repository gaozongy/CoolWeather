import 'dart:convert';
import 'dart:io';

import 'package:coolweather/bean/focus_district_list_bean.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDistrictPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddDistrictPageState();
  }
}

class AddDistrictPageState extends StatefulWidget {
  AddDistrictPageState({Key key}) : super(key: key);

  @override
  _AddDistrictPageStateState createState() => _AddDistrictPageStateState();
}

class _AddDistrictPageStateState extends State<AddDistrictPageState> {
  List<District> focusDistrictList = [];

  List<District> hotCityList = [];

  List<District> queryCityList = [];

  bool isLoading = false;

  String oldKeyword = "";

  bool isKeywordEmpty = true;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initFocusedCityData();
    initHotCityData();
    initListener();
  }

  void initListener() {
    textEditingController.addListener(() {
      String keyword = textEditingController.text;
      if (keyword != oldKeyword) {
        setState(() {
          isKeywordEmpty = isEmpty(keyword);
        });
        if (!isKeywordEmpty) {
          queryCity(keyword);
        }
        oldKeyword = keyword;
      }
    });
  }

  initFocusedCityData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusDistrictListBean focusDistrictListBean;
    String focusCountyJson = prefs.getString('focus_district_data');
    if (!isEmpty(focusCountyJson)) {
      focusDistrictListBean =
          FocusDistrictListBean.fromJson(json.decode(focusCountyJson));
      if (focusDistrictListBean != null) {
        setState(() {
          focusDistrictList = focusDistrictListBean.districtList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actionBtnList = List();
    if (!isKeywordEmpty) {
      actionBtnList.add(IconButton(
          icon: new Icon(Icons.clear),
          onPressed: () {
            textEditingController.clear();
          }));
    }

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            autofocus: true,
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: "城市名",
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
            ),
          ),
          actions: actionBtnList,
          elevation: 1,
        ),
        body: cityListLayout(isKeywordEmpty));
  }

  Widget cityListLayout(bool isKeywordEmpty) {
    if (isKeywordEmpty) {
      return hotCityLayout();
    } else {
      return queryCityLayout();
    }
  }

  Widget hotCityLayout() {
    List<Widget> cityItemList = List();
    hotCityList.forEach((city) {
      bool hasAdded = false;
      focusDistrictList.forEach((focusDistrict) {
        if (equalsIgnoreCase(focusDistrict.cityCode, city.cityCode) &&
            equalsIgnoreCase(focusDistrict.adCode, city.adCode)) {
          hasAdded = true;
        }
      });
      cityItemList.add(
        Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            //设置点击事件回调
            onTap: () {
              if (!hasAdded) {
                saveFocusCity(city);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 22),
              child: Text(
                city.name,
                style: TextStyle(
                    color: hasAdded ? Colors.blue : Colors.black, fontSize: 12),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      );
    });

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "热门城市",
              style: TextStyle(fontSize: 13, color: Colors.blue),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Wrap(
                  spacing: 10,
                  runSpacing: 20,
                  alignment: WrapAlignment.start,
                  children: cityItemList),
            )
          ]),
    );
  }

  Widget queryCityLayout() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          )
        : ListView.builder(
            itemCount: queryCityList.length,
            itemBuilder: (BuildContext context, int position) {
              var itemData = queryCityList.elementAt(position);
              return cityRow(itemData);
            });
  }

  Widget cityRow(District district) {
    bool hasAdded = false;
    focusDistrictList.forEach((focusDistrict) {
      if (equalsIgnoreCase(focusDistrict.cityCode, district.cityCode) &&
          equalsIgnoreCase(focusDistrict.adCode, district.adCode)) {
        hasAdded = true;
      }
    });

    List<Widget> widgetList = List();
    widgetList.add(Text(district.name, style: TextStyle(fontSize: 17)));
    if (hasAdded) {
      widgetList.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child:
              Text("已关注", style: TextStyle(fontSize: 8, color: Colors.white)),
          decoration: new BoxDecoration(
            color: Colors.blue,
            borderRadius: new BorderRadius.circular(5),
          )));
    }

    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widgetList,
            ),
            Text(district.addressDesc,
                style: TextStyle(fontSize: 13, color: Colors.grey))
          ],
        ),
      ),
      onTap: () {
        if (!hasAdded) {
          saveFocusCity(district);
        }
      },
    );
  }

  void queryCity(String keyword) async {
    setState(() {
      isLoading = true;
    });

    String parameter = '&keywords=' +
        keyword +
        '&type=190103|190104|190105|190106|190107|190108|190109';
    String url =
        'https://restapi.amap.com/v3/assistant/inputtips?key=38366adde7d7ec1e94d652f9e90f78ce' +
            parameter;

    HttpClient httpClient = new HttpClient();
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        Map map = jsonDecode(json);
        List list = map['tips'];
        List<District> cityList = [];
        list.forEach((district) {
          var location = district['location'];
          if (location is String) {
            List<String> strList = location.split(',');
            cityList.add(District(
                district["id"],
                district["adcode"],
                district["name"],
                double.parse(strList[1]),
                double.parse(strList[0]),
                addressDesc: district["district"]));
          }
        });

        setState(() {
          isLoading = false;
          queryCityList.clear();
          queryCityList.addAll(cityList);
        });
      }
    } catch (ignore) {}
  }

  void saveFocusCity(District city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusDistrictListBean focusDistrictListBean;
    String focusCountyJson = prefs.getString('focus_district_data');
    if (!isEmpty(focusCountyJson)) {
      focusDistrictListBean =
          FocusDistrictListBean.fromJson(json.decode(focusCountyJson));
    }

    if (focusDistrictListBean == null) {
      focusDistrictListBean = new FocusDistrictListBean(new List<District>());
    }
    focusDistrictListBean.districtList.add(city);
    focusCountyJson = jsonEncode(focusDistrictListBean.toJson());
    prefs.setString('focus_district_data', focusCountyJson);
    Navigator.pop(context, true);
  }

  initHotCityData() {
    District beiJing = District("010", "110100", "北京", 39.928353, 116.416357);
    District shangHai = District("021", "310100", "上海", 31.230416, 121.473701);
    District shenZhen = District("0755", "440301", "深圳", 22.543099, 114.057868);
    District guangZhou = District("020", "440101", "广州", 23.129162, 113.264434);
    District changChun =
        District("0431", "220101", "长春", 43.817071, 125.323544);
    District changSha = District("0731", "430101", "长沙", 28.12, 113.05);
    District chengDu = District("028", "510101", "成都", 30.572269, 104.066541);
    District chongQing = District("023", "500100", "重庆", 29.291965, 108.170255);
    District fuZhou = District("0591", "350101", "福州", 26.074507, 119.296494);
    District guiYang = District("0851", "520101", "贵阳", 29.291965, 108.170255);
    District hangZhou = District("0571", "330101", "杭州", 26.647661, 106.630153);
    District haErBing =
        District("0451", "230101", "哈尔滨", 45.756967, 126.642464);
    District heFei = District("0551", "340101", "合肥", 31.820586, 117.227239);
    District jiNan = District("0531", "370101", "济南", 36.675807, 117.000923);
    District kunMing = District("0871", "530101", "昆明", 25.040609, 102.712251);
    District lanZhou = District("0931", "620101", "兰州", 36.061089, 103.834303);
    District nanChang = District("0791", "360101", "南昌", 28.682892, 115.858197);
    District nanJing = District("025", "320101", "南京", 32.060255, 118.796877);
    District nanNing = District("0771", "450101", "南宁", 22.817002, 108.366543);
    District shenYang = District("024", "210101", "沈阳", 41.805698, 123.431474);

    hotCityList.add(beiJing);
    hotCityList.add(shangHai);
    hotCityList.add(shenZhen);
    hotCityList.add(guangZhou);
    hotCityList.add(changChun);
    hotCityList.add(changSha);
    hotCityList.add(chengDu);
    hotCityList.add(chongQing);
    hotCityList.add(fuZhou);
    hotCityList.add(guiYang);
    hotCityList.add(hangZhou);
    hotCityList.add(haErBing);
    hotCityList.add(heFei);
    hotCityList.add(jiNan);
    hotCityList.add(kunMing);
    hotCityList.add(lanZhou);
    hotCityList.add(nanChang);
    hotCityList.add(nanJing);
    hotCityList.add(nanNing);
    hotCityList.add(shenYang);
  }
}
