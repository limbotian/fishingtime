import 'dart:async';
import 'package:fishingtime/anim/cartoon.dart';
import 'package:fishingtime/models/setting.dart';
import 'package:fishingtime/pages/default_clock_setting.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class DefaultClock extends StatefulWidget {
  static const KEY = "DEFAULT";

  @override
  _DefaultClockState createState() => _DefaultClockState();
}

class _DefaultClockState extends State<DefaultClock> {
  var _clockFontStyle = TextStyle(
      color: Colors.white,
      fontSize: ScreenUtil().setSp(200),
      fontFamily: 'JetBrainsMono');
  Color _cardColor;
  Color _backgroundColor;
  var _time = ['0', '0', '0', '0', '0', '0'];
  var _timer;
  var _isOLed;
  var _margin = [0.0, 0.0, 0.0, 0.0];
  bool _isShowSed = true;

  Widget _getTextContainer(text) {
    var sen = double.parse(_time[4] + _time[5]);
    return new AnimatedContainer(
      height: ScreenUtil().screenHeight / 1.8,
      width: ScreenUtil().screenWidth / (_isShowSed ? 7 : 5),
      margin: EdgeInsets.fromLTRB(
        ScreenUtil().setHeight(_margin[0]),
        ScreenUtil().setHeight(_margin[1]),
        ScreenUtil().setHeight(_margin[2]),
        ScreenUtil().setHeight(_margin[3]),
      ),
      alignment: Alignment.center,
      curve: Curves.ease,
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.all(Radius.circular(sen * 0.5))),
      child: new Text(
        text,
        style: _clockFontStyle,
      ),
    );
  }

  List _getConList() {
    int count = _isShowSed ? _time.length : 4;
    List<Widget> result = new List(count);
    for (var i = 0; i < count; i++) {
      result[i] = _getTextContainer(_time[i]);
    }
    return result;
  }

  @override
  void initState() {
    setState(() {
      _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        ///定时任务
        _flushTime();
      });
    });
    super.initState();
  }

  void _flushTime() {
    DateTime now = DateTime.now(); //获取当前时间
    String formattedDate = DateFormat('HHmmss').format(now); //格式化日期
    setState(() {
      _time = [
        formattedDate[0],
        formattedDate[1],
        formattedDate[2],
        formattedDate[3],
        formattedDate[4],
        formattedDate[5],
      ];

      if (_isOLed) {
        (ScreenUtil().screenHeight);
        var d = (double.parse(_time[4] + _time[5]) - 30) *
            ScreenUtil().screenHeight /
            30;
        _margin = [0, d > 0 ? d : 0, 0, -(d) > 0 ? -(d) : 0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _setting = Provide.value<Setting>(context);
    final _theme = Theme.of(context);
    setState(() {
      _isOLed = _setting.isOLed;
      _clockFontStyle = TextStyle(
          color: _setting.colorWithTheme
              ? _theme.colorScheme.onSurface
              : Color(_setting.dFTextColor).withOpacity(_setting.dFTextOpacity),
          fontSize: ScreenUtil().setSp(200));
      _cardColor = _setting.colorWithTheme
          ? _theme.colorScheme.secondary
          : Color(_setting.dFCardColor).withOpacity(_setting.dFCardOpacity);
      _backgroundColor = _setting.colorWithTheme
          ? _theme.colorScheme.secondaryVariant
          : Color(_setting.dFBackgroundColor)
              .withOpacity(_setting.dFBackgroundOpacity);
      _isShowSed = _setting.isShowSed;
    });

    return GestureDetector(
      onVerticalDragEnd: (details) async {
        if (details.primaryVelocity == 0) {
          return;
        }
        if (details.primaryVelocity < 0) {
          await Navigator.push(
              context, CustomRouteSlideBTT(DefaultClockSetting()));
        }
      },
      child: Stack(
        overflow: Overflow.clip,
        children: [
          Container(
            decoration: BoxDecoration(color: _backgroundColor),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _getConList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ///取消计时器
    _timer?.cancel();
    super.dispose();
  }
}
