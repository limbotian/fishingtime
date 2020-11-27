import 'package:fishingtime/models/setting.dart';
import 'package:fishingtime/widgets/setting_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var _subTitleStyle =
      TextStyle(fontSize: ScreenUtil().setSp(15), color: Colors.grey);
  var _titleTextStyle = TextStyle();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _setting = Provide.value<Setting>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SETTING'),
        backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryVariant),
        child: new ListView(
          children: [
            SettingCardItem(
                child: new ListTile(
                    leading: Icon(Icons.fullscreen),
                    title: new Text(
                      '全屏显示',
                      style: _titleTextStyle,
                    ),
                    trailing: new Switch(
                        value: _setting.isFullScreen,
                        onChanged: (bool newValue) {
                          setState(() {
                            _setting.isFullScreen = newValue;
                          });
                          if (newValue) {
                            SystemChrome.setEnabledSystemUIOverlays([]);
                          } else {
                            SystemChrome.setEnabledSystemUIOverlays(
                                [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                          }
                        }))),
            SettingCardItem(
                child: new ListTile(
                    leading: Icon(Icons.all_out),
                    title: new Text('OLED防烧屏', style: _titleTextStyle),
                    trailing: new Switch(
                        value: _setting.isOLed,
                        onChanged: (bool newValue) {
                          setState(() {
                            _setting.isOLed = newValue;
                          });
                        }))),
            SettingCardItem(
              child: new ListTile(
                leading: Icon(Icons.swap_horiz),
                title: new Text('强制横屏', style: _titleTextStyle),
                trailing: new Switch(
                    value: _setting.isHorizontal,
                    onChanged: (bool newValue) {
                      setState(() {
                        _setting.isHorizontal = newValue;
                      });

                      if (newValue) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight
                        ]);
                      } else {
                        SystemChrome.setPreferredOrientations([]);
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
