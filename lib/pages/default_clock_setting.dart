import 'package:fishingtime/constants.dart';
import 'package:fishingtime/models/setting.dart';
import 'package:fishingtime/widgets/cust_modal_bottom_sheet.dart';
import 'package:fishingtime/widgets/setting_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class DefaultClockSetting extends StatefulWidget {
  @override
  _DefaultClockSettingState createState() => _DefaultClockSettingState();
}

class _DefaultClockSettingState extends State<DefaultClockSetting> {
  TextStyle _textStyle;
  TextStyle _subTextStyle = Constants.SUB_TITLE_STYLE;
  Setting _setting;
  List _colors = new List(1);
  Color pickerColor = Color(0xff443a49);

  @override
  void initState() {
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

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
                    _setting.dFCardColor = pickerColor.value;
                    _setting.dFCardOpacity = pickerColor.opacity;
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

  @override
  Widget build(BuildContext context) {
    _setting = Provide.value<Setting>(context);
    final _theme = Theme.of(context);
    setState(() {
      _colors[0] = Color(_setting.dFBackgroundColor)
          .withOpacity(_setting.dFBackgroundOpacity);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('CURRENT CLOCK SETTING'),
        backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
        color: _theme.colorScheme.secondaryVariant,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: ListView(
                children: [
                  SettingCardItem(
                    child: ListTile(
                      isThreeLine: false,
                      leading: Icon(Icons.color_lens),
                      title: Text(
                        '卡片颜色',
                        style: _textStyle,
                      ),
                      subtitle: Text(
                        '#' +
                            _setting.dFCardColor
                                .toRadixString(16)
                                .toUpperCase(),
                        style: _subTextStyle,
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
                    child: new ListTile(
                        leading: Icon(Icons.av_timer),
                        title: Text('显示秒钟', style: _textStyle),
                        trailing: new Switch(
                            value: _setting.isShowSed,
                            onChanged: (bool newValue) {
                              setState(() {
                                _setting.isShowSed = newValue;
                              });
                            })),
                  ),
                  SettingCardItem(
                    child: new ListTile(
                        leading: Icon(Icons.panorama_fish_eye),
                        title: Text('显示点', style: _textStyle),
                        trailing: new Switch(
                            value: _setting.showDot,
                            onChanged: (bool newValue) {
                              setState(() {
                                _setting.showDot = newValue;
                              });
                            })),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  SettingCardItem(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.help),
                          title: Text(
                            '关闭颜色跟随主题才可自定义颜色。',
                            style: _textStyle,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
