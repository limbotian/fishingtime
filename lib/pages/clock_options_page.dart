import 'dart:ui';

import 'package:fishingtime/models/setting.dart';
import 'package:fishingtime/pages/circle_clock.dart';
import 'package:fishingtime/pages/default_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class ClockOptionPage extends StatefulWidget {
  @override
  _ClockOptionPageState createState() => _ClockOptionPageState();
}

class _ClockOptionPageState extends State<ClockOptionPage> {
  var _setting;
  var _clocks;
  var _clocksKey;
  var _clocksName;
  var _clocksTextStyle =
      TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(25));

  @override
  void initState() {
    setState(() {
      //
      _clocks = [
        new DefaultClock(),
        new CircleClock(),
      ];
      _clocksKey = [
        DefaultClock.KEY,
        CircleClock.KEY,
      ];
      _clocksName = ["Default", "CircleClock"];
    });
    super.initState();
  }

  Widget _clocksCon(widget, text, index) {
    return GestureDetector(
      onTap: () {
        _saveCurrentClock(index);
      },
      child: Container(
        margin: EdgeInsetsDirectional.fromSTEB(32, 0, 32, 8),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Theme.of(context).colorScheme.secondary,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            new Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: ScreenUtil().setHeight(1280),
              width: ScreenUtil().setWidth(1024),
              child: widget,
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                text,
                style: _clocksTextStyle,
              ),
            )
          ]),
        ),
      ),
    );
  }

  _saveCurrentClock(index) {
    setState(() {
      _setting.currentClockKey = _clocksKey[index];
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _setting = Provide.value<Setting>(context);
    });

    _getList() {
      if (_clocks == null || _clocks.length == 0) {
        return new List();
      }
      var list = new List<Widget>(_clocks.length);
      for (var i = 0; i < _clocks.length; i++) {
        list[i] = _clocksCon(_clocks[i], _clocksName[i], i);
      }
      return list;
    }

    return Scaffold(
      appBar: new AppBar(
        title: new Text("CLOCKS"),
        backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      ),
      body: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryVariant),
        child: new ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(10, 0, 90, 0),
          children: _getList(),
        ),
      ),
    );
  }
}
