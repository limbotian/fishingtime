import 'package:fishingtime/constants.dart';
import 'package:fishingtime/main.dart';
import 'package:fishingtime/models/setting.dart';
import 'package:fishingtime/widgets/cust_alert_dialog.dart';
import 'package:fishingtime/widgets/cust_modal_bottom_sheet.dart';
import 'package:fishingtime/widgets/setting_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:provide/provide.dart';
import 'package:url_launcher/url_launcher.dart';

enum Action { Ok, Cancel }

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var _subTitleStyle = Constants.SUB_TITLE_STYLE;
  var _titleTextStyle;
  var version = '0.0';
  Color pickerColor = Color(0xff443a49);
  List _colors = new List(2);
  Setting _setting;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
    super.initState();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    _setting = Provide.value<Setting>(context);
    setState(() {
      _colors[0] = Color(_setting.dFBackgroundColor)
          .withOpacity(_setting.dFBackgroundOpacity);
      _colors[1] =
          Color(_setting.dFTextColor).withOpacity(_setting.dFTextOpacity);
    });
    void _showColorChooseDialog(int index) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _colors[index],
              onColorChanged: changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() {
                  switch (index) {
                    case 0:
                      _setting.dFBackgroundColor = pickerColor.value;
                      _setting.dFBackgroundOpacity = pickerColor.opacity;
                      break;
                    case 1:
                      _setting.dFTextColor = pickerColor.value;
                      _setting.dFTextOpacity = pickerColor.opacity;
                      break;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('SETTING'),
        backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
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
            ),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            SettingCardItem(
              child: ListTile(
                leading: Icon(Icons.format_color_reset),
                title: Text(
                  '颜色跟随主题',
                  style: _titleTextStyle,
                ),
                trailing: new Switch(
                    value: _setting.colorWithTheme,
                    onChanged: (bool newValue) {
                      setState(() {
                        _setting.colorWithTheme = newValue;
                      });
                    }),
              ),
            ),
            SettingCardItem(
              child: ListTile(
                leading: Icon(Icons.wallpaper),
                title: Text(
                  '背景颜色',
                  style: _titleTextStyle,
                ),
                subtitle: Text(
                  '#' +
                      _setting.dFBackgroundColor
                          .toRadixString(16)
                          .toUpperCase(),
                  style: _subTitleStyle,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                ),
                onTap: () {
                  _showColorChooseDialog(0);
                },
                enabled: !_setting.colorWithTheme,
              ),
            ),
            SettingCardItem(
              child: ListTile(
                leading: Icon(Icons.text_fields),
                title: Text(
                  '文字颜色',
                  style: _titleTextStyle,
                ),
                subtitle: Text(
                  '#' + _setting.dFTextColor.toRadixString(16).toUpperCase(),
                  style: _subTitleStyle,
                ),
                trailing: Icon(
                  Icons.arrow_right,
                ),
                onTap: () {
                  _showColorChooseDialog(1);
                },
                enabled: !_setting.colorWithTheme,
              ),
            ),
            SettingCardItem(
              child: new ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('显示日期', style: _titleTextStyle),
                  trailing: new Switch(
                      value: _setting.isShowDate,
                      onChanged: (bool newValue) {
                        setState(() {
                          _setting.isShowDate = newValue;
                        });
                      })),
            ),
            SettingCardItem(
              child: new ListTile(
                leading: Icon(Icons.speaker_notes),
                title: Text('骚话', style: _titleTextStyle),
                trailing: SizedBox(
                  width: ScreenUtil().setWidth(500),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.right,
                    onChanged: (value) {
                      if (_setting.custText == value) {
                        return;
                      }
                      setState(() {
                        _setting.custText = value;
                      });
                    },
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text:
                            '${_setting.custText == null ? "" : _setting.custText}', //判断keyword是否为空
                        // 保持光标在最后
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: '${_setting.custText}'.length,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SettingCardItem(
              child: ListTile(
                leading: Icon(Icons.font_download),
                title: Text(
                  '时钟字体',
                ),
                trailing: SizedBox(
                  width: ScreenUtil().setWidth(500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("JetBrainsMono:"),
                      Radio(
                        value: "JetBrainsMono",
                        groupValue: _setting.dFClockFontFamily,
                        onChanged: (value) {
                          setState(() {
                            _setting.dFClockFontFamily = value;
                          });
                        },
                      ),
                      Text("Led:"),
                      Radio(
                        value: "Led",
                        groupValue: _setting.dFClockFontFamily,
                        onChanged: (value) {
                          setState(() {
                            _setting.dFClockFontFamily = value;
                          });
                        },
                      ),
                      Text("系统:"),
                      Radio(
                        value: "",
                        groupValue: _setting.dFClockFontFamily,
                        onChanged: (value) {
                          setState(() {
                            _setting.dFClockFontFamily = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            SettingCardItem(
              child: new ListTile(
                leading: Icon(Icons.restore),
                title: new Text('重置', style: _titleTextStyle),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  openAlertDialog(context, "是否重置").then((value) {
                    if (Action.Ok.toString() == value.toString()) {
                      RestartWidget.restartApp(context);
                    }
                  });
                },
              ),
            ),
            SettingCardItem(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text(
                      '此项目开源，点击查看具体信息。',
                      style: _titleTextStyle,
                    ),
                    trailing: Icon(
                      Icons.open_in_browser,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      _launchURL(Constants.GITHUB_URL);
                    },
                  ),
                ],
              ),
            ),
            SettingCardItem(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: Text(
                      'Email',
                      style: _titleTextStyle,
                    ),
                    subtitle: Text(
                      Constants.EMAIL,
                      style: _subTitleStyle,
                    ),
                    trailing: Icon(
                      Icons.forward_to_inbox,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      final Uri _emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: Constants.EMAIL,
                          queryParameters: {'subject': 'Example Subject'});
                      launch(_emailLaunchUri.toString());
                    },
                  ),
                ],
              ),
            ),
            SettingCardItem(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text(
                      'Version',
                      style: _titleTextStyle,
                    ),
                    subtitle: Text(
                      '点击查看更新',
                      style: _subTitleStyle,
                    ),
                    trailing: Text(version),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
