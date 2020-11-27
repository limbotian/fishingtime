import 'package:fishingtime/models/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provide/provide.dart';

class DefaultClockSetting extends StatefulWidget {
  @override
  _DefaultClockSettingState createState() => _DefaultClockSettingState();
}

class _DefaultClockSettingState extends State<DefaultClockSetting> {
  TextStyle _textStyle;
  Color _textColor;
  Setting _setting;
  List _colors = new List(3);
  List _opacity = new List(3);
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
                    _setting.dFBackgroundColor = pickerColor.value;
                    _setting.dFBackgroundOpacity = pickerColor.opacity;
                    break;
                  case 1:
                    _setting.dFTextColor = pickerColor.value;
                    _setting.dFTextOpacity = pickerColor.opacity;
                    break;
                  case 2:
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
      _textStyle = TextStyle(
          color: _setting.colorWithTheme
              ? _theme.colorScheme.onSurface
              : Color(_setting.dFTextColor).withOpacity(_setting.dFTextOpacity),
          fontFamily: "JetBrainsMono");
      _textColor = _setting.colorWithTheme
          ? _theme.colorScheme.onSurface
          : Color(_setting.dFTextColor).withOpacity(_setting.dFTextOpacity);
      _colors[0] = Color(_setting.dFBackgroundColor)
          .withOpacity(_setting.dFBackgroundOpacity);
      _colors[1] =
          Color(_setting.dFTextColor).withOpacity(_setting.dFTextOpacity);
      _colors[2] =
          Color(_setting.dFCardColor).withOpacity(_setting.dFCardOpacity);
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_downward,
          color: _theme.accentColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
        color: _setting.colorWithTheme
            ? _theme.colorScheme.secondaryVariant
            : Color(_setting.dFBackgroundColor)
                .withOpacity(_setting.dFBackgroundOpacity),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: ListView(
                children: [
                  SettingCardItem(
                    child: ListTile(
                      leading: Icon(
                        Icons.format_color_reset,
                        color: _textColor,
                      ),
                      title: Text(
                        '颜色跟随主题',
                        style: _textStyle,
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
                      leading: Icon(
                        Icons.wallpaper,
                        color: _textColor,
                      ),
                      title: Text(
                        '背景颜色',
                        style: _textStyle,
                      ),
                      trailing: Icon(
                        Icons.colorize,
                        color: Theme.of(context).accentColor,
                      ),
                      onTap: () {
                        _showColorChooseDialog(0);
                      },
                      enabled: !_setting.colorWithTheme,
                    ),
                  ),
                  SettingCardItem(
                    child: ListTile(
                      leading: Icon(
                        Icons.text_fields,
                        color: _textColor,
                      ),
                      title: Text(
                        '文字颜色',
                        style: _textStyle,
                      ),
                      trailing: Icon(
                        Icons.colorize,
                        color: Theme.of(context).accentColor,
                      ),
                      onTap: () {
                        _showColorChooseDialog(1);
                      },
                      enabled: !_setting.colorWithTheme,
                    ),
                  ),
                  SettingCardItem(
                    child: ListTile(
                      leading: Icon(
                        Icons.color_lens,
                        color: _textColor,
                      ),
                      title: Text(
                        '卡片颜色',
                        style: _textStyle,
                      ),
                      trailing: Icon(
                        Icons.colorize,
                        color: Theme.of(context).accentColor,
                      ),
                      onTap: () {
                        _showColorChooseDialog(2);
                      },
                      enabled: !_setting.colorWithTheme,
                    ),
                  ),
                  SettingCardItem(
                    child: new ListTile(
                        leading: Icon(
                          Icons.av_timer,
                          color: _textColor,
                        ),
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
                    child: ListTile(
                      leading: Icon(
                        Icons.font_download,
                        color: _textColor,
                      ),
                      title: Text(
                        '字体',
                        style: _textStyle,
                      ),
                      trailing: Text(
                        _textStyle.fontFamily,
                        style: _textStyle,
                      ),
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

class SettingCardItem extends StatelessWidget {
  final Widget child;

  const SettingCardItem({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _setting = Provide.value<Setting>(context);
    final _theme = Theme.of(context);
    return Container(
        margin: EdgeInsetsDirectional.fromSTEB(32, 4, 32, 4),
        child: Material(
          child: child,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          color: _setting.colorWithTheme
              ? _theme.colorScheme.secondary
              : Color(_setting.dFCardColor).withOpacity(_setting.dFCardOpacity),
        ));
  }
}
