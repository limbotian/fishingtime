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
  var _clockFontStyle =
      TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(200));
  Color _cardColor;
  Color _backgroundColor;
  var _time = ['0', '0', '0'];
  var _date = '';
  var _custText = '';
  var _timer;
  var _isOLed;
  var _isShowDate;
  var _margin = [0.0, 0.0, 0.0, 0.0];
  bool _isShowSed = true;
  bool _isShowDot = true;

  Widget _getTextContainer(text) {
    var sen = double.parse(_time[2]);
    return new AnimatedContainer(
      height: ScreenUtil().screenHeight / 1.8,
      width: ScreenUtil().screenWidth / (_isShowSed ? 4 : 3),
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
    int count = _isShowSed ? _time.length : 2;
    List<Widget> result = new List();
    for (var i = 0; i < count; i++) {
      if (_isShowDot && i / 2 != 0) {
        result.add(_getDot());
      }
      result.add(_getTextContainer(_time[i]));
    }
    return result;
  }

  Widget _getDot() {
    return AnimatedContainer(
      height: ScreenUtil().screenHeight / 2.5,
      width: ScreenUtil().screenWidth / 20,
      margin: EdgeInsets.fromLTRB(
        ScreenUtil().setHeight(_margin[0]),
        ScreenUtil().setHeight(_margin[1]),
        ScreenUtil().setHeight(_margin[2]),
        ScreenUtil().setHeight(_margin[3]),
      ),
      alignment: Alignment.center,
      curve: Curves.ease,
      duration: Duration(seconds: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: ScreenUtil().setWidth(30),
            decoration: BoxDecoration(
              color: _cardColor,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(30),
            decoration: BoxDecoration(
              color: _cardColor,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
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
        formattedDate[0] + formattedDate[1],
        formattedDate[2] + formattedDate[3],
        formattedDate[4] + formattedDate[5],
      ];
      if (_isShowDate) {
        _date = DateFormat('yyyy-MM-dd').format(now); //格式化日期
      } else {
        _date = '';
      }
      if (_isOLed) {
        var d = (double.parse(_time[2]) - 30) * ScreenUtil().screenWidth / 60;
        _margin = [0, d > 0 ? d : 0, 0, -(d) > 0 ? -(d) : 0];
      } else {
        _margin = [0, 0, 0, 0];
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
          fontSize: ScreenUtil().setSp(200),
          fontFamily: _setting.dFClockFontFamily);
      _cardColor = _setting.colorWithTheme
          ? _theme.colorScheme.secondary
          : Color(_setting.dFCardColor).withOpacity(_setting.dFCardOpacity);
      _backgroundColor = _setting.colorWithTheme
          ? _theme.colorScheme.secondaryVariant
          : Color(_setting.dFBackgroundColor)
              .withOpacity(_setting.dFBackgroundOpacity);
      _isShowSed = _setting.isShowSed;
      _isShowDot = _setting.showDot;
      _isShowDate = _setting.isShowDate;
      _custText = _setting.custText;
      if (_setting.isOLed &&
          int.parse(_time[2]) <= 5 &&
          int.parse(_time[2]) >= 0) {
        _backgroundColor = Colors.black;
        _cardColor = Colors.black;
      }
    });

    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, CustomRouteZoom(DefaultClockSetting()));
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
          Container(
              margin:
                  EdgeInsets.all(_setting.isOLed ? double.parse(_time[2]) : 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _date,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      fontFamily: _setting.dFClockFontFamily,
                      color: _clockFontStyle.color,
                    ),
                  ),
                  Text(
                    _custText,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(23),
                      fontFamily: _setting.dFClockFontFamily,
                      color: _clockFontStyle.color,
                    ),
                  ),
                ],
              ))
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
