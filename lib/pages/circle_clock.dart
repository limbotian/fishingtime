import 'dart:async';

import 'package:fishingtime/models/setting.dart';
import 'package:fishingtime/widgets/container_hand.dart';
import 'package:fishingtime/widgets/drawn_hand.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provide/provide.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class CircleClock extends StatefulWidget {
  static const KEY = "CIRCLE_CLOCK";
  CircleClock({Key key}) : super(key: key);
  @override
  _CircleClockState createState() => _CircleClockState();
}

class _CircleClockState extends State<CircleClock> {
  Color _backgroundColor;
  Color _circleColor;
  var _time = ['0', '0', '0'];
  var _date = '';
  var _custText = '';
  var _timer;
  var _isOLed;
  var _isShowDate;
  var _margin = [0.0, 0.0, 0.0, 0.0];
  final radiansPerTick = radians(360 / 60);
  ThemeData _theme;

  /// Total distance traveled by an hour hand, each hour, in radians.
  final radiansPerHour = radians(360 / 12);

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
        var d = (double.parse(_time[2]) - 30) * ScreenUtil().screenWidth / 150;
        _margin = [0, d > 0 ? d : 0, 0, -(d) > 0 ? -(d) : 0];
      } else {
        _margin = [0, 0, 0, 0];
      }
    });
  }

  Widget _getCircle({double sen}) {
    var margin = [0.0, 0.0, 0.0, 0.0];
    //sen = sen - 15;
    if (sen >= 0 && sen < 15) {
      margin[0] = 15 - sen;
      margin[1] = sen;
      margin[2] = 0;
      margin[3] = 0;
    } else if (sen >= 15 && sen < 30) {
      margin[1] = 30 - sen;
      margin[2] = sen - 15;
      margin[0] = 0;
      margin[3] = 0;
    } else if (sen >= 30 && sen < 45) {
      margin[2] = 45 - sen;
      margin[3] = sen - 30;
      margin[0] = 0;
      margin[1] = 0;
    } else if (sen >= 45 && sen < 60) {
      margin[3] = 60 - sen;
      margin[0] = sen - 45;
      margin[1] = 0;
      margin[2] = 0;
    }
    return AnimatedContainer(
      margin: EdgeInsets.fromLTRB(margin[0], margin[1], margin[2], margin[3]),
      curve: Curves.ease,
      duration: Duration(seconds: 1),
      width: ScreenUtil().setWidth(450),
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: _theme.colorScheme.secondary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _setting = Provide.value<Setting>(context);
    _theme = Theme.of(context);
    setState(() {
      _isOLed = _setting.isOLed;
      _backgroundColor = _setting.colorWithTheme
          ? _theme.colorScheme.secondaryVariant
          : Color(_setting.dFBackgroundColor)
              .withOpacity(_setting.dFBackgroundOpacity);
      _circleColor = _setting.colorWithTheme
          ? _theme.colorScheme.secondary
          : Color(_setting.dFCardColor).withOpacity(_setting.dFCardOpacity);
      _isShowDate = _setting.isShowDate;
      _custText = _setting.custText;
      if (_setting.isOLed &&
          _time[1].indexOf('5') != -1 &&
          int.parse(_time[2]) <= 3 &&
          int.parse(_time[2]) >= 0) {
        _backgroundColor = Colors.black;
        _circleColor = Colors.black;
      }
    });
    return GestureDetector(
      child: Stack(
        overflow: Overflow.clip,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _backgroundColor,
            ),
            child: AnimatedContainer(
              curve: Curves.ease,
              duration: Duration(seconds: 1),
              width: ScreenUtil().setWidth(450),
              margin: EdgeInsets.fromLTRB(
                ScreenUtil().setHeight(_margin[0]),
                ScreenUtil().setHeight(_margin[1]),
                ScreenUtil().setHeight(_margin[2]),
                ScreenUtil().setHeight(_margin[3]),
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border:
                    Border.all(color: _theme.colorScheme.secondary, width: 2),
              ),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: ScreenUtil().setWidth(230)),
                    child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(200),
                      child: Container(
                        alignment: Alignment.center,
                        color: _backgroundColor,
                        child: Text(
                          _time[0] + ':' + _time[1] + ':' + _time[2],
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            fontFamily: _setting.dFClockFontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _getCircle(
                    sen: double.parse(_time[2]),
                  ),
                  _getCircle(
                    sen: (double.parse(_time[2]) - 15) <= 0
                        ? 45 + double.parse(_time[2])
                        : double.parse(_time[2]) - 15,
                  ),
                  DrawnHand(
                    color: _theme.colorScheme.onSurface,
                    thickness: 13,
                    size: 0.4,
                    angleRadians: int.parse(_time[0]) * radiansPerTick,
                  ),
                  DrawnHand(
                    color: _theme.colorScheme.primaryVariant,
                    thickness: 10,
                    size: 0.6,
                    angleRadians: int.parse(_time[1]) * radiansPerTick,
                  ),
                  DrawnHand(
                    color: _theme.colorScheme.primary,
                    thickness: 5,
                    size: 0.8,
                    angleRadians: int.parse(_time[2]) * radiansPerTick,
                  ),
                  DrawnHand(
                    color: _theme.colorScheme.primary,
                    thickness: 30,
                    size: 0,
                    angleRadians: 0,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(
                _setting.isOLed ? double.parse(_time[2]) + 10 : 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _date,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                    fontFamily: _setting.dFClockFontFamily,
                  ),
                ),
                Text(
                  _custText,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(23),
                    fontFamily: _setting.dFClockFontFamily,
                  ),
                ),
              ],
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
