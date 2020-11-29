import 'package:fishingtime/models/setting.dart';
import 'package:fishingtime/pages/clock_options_page.dart';
import 'package:fishingtime/pages/default_clock.dart';
import 'package:fishingtime/pages/setting_page.dart';
import 'package:flutter/services.dart';
import 'package:provide/provide.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';

import 'anim/cartoon.dart';

class MainPageController extends StatefulWidget {
  @override
  _MainPageControllerState createState() => _MainPageControllerState();
}

class _MainPageControllerState extends State<MainPageController> {
  @override
  void initState() {
    //屏幕常亮
    Wakelock.enable();
    super.initState();
  }

  Widget _getCurrentClock(currentClockKey) {
    var _currentClock;
    switch (currentClockKey) {
      case DefaultClock.KEY:
        _currentClock = new DefaultClock();
        break;
      default:
        _currentClock = new DefaultClock();
        break;
    }
    return _currentClock;
  }

  @override
  Widget build(BuildContext context) {
    final _setting = Provide.value<Setting>(context);
    if (_setting.isFullScreen) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
    if (_setting.isHorizontal) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }

    return Stack(
      children: [
        Container(
          child: _getCurrentClock(_setting.currentClockKey),
        ),
        GestureDetector(
          onHorizontalDragEnd: (details) async {
            if (details.primaryVelocity == 0) {
              return;
            }
            if (details.primaryVelocity > 0) {
              await Navigator.push(
                  context, CustomRouteSlideLTR(ClockOptionPage()));
            } else if (details.primaryVelocity < 0) {
              await Navigator.push(context, CustomRouteSlideRTL(SettingPage()));
            }
            setState(() {});
          },
        ),
      ],
    );
  }
}
