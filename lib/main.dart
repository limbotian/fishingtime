import 'package:fishingtime/constants.dart';
import 'package:fishingtime/main_page_controller.dart';
import 'package:fishingtime/models/setting.dart';
import 'package:fishingtime/theme/AppThemeData.dart';
import 'package:fishingtime/utils/setting_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runRealApp();
}

void runRealApp() async {
  var sp = await SharedPreferences.getInstance();
  var bool = sp.getBool(Constants.IS_INITED_KEY);
  if (bool == null || bool == false) {
    SettingUtil.initDefaultSetting(sp);
  }

  Setting setting = Setting();
  var isInit = sp.getBool(Constants.IS_INITED_KEY);
  var isFullScreen = sp.getBool(Constants.IS_FULL_SCREEN_KEY);
  var isOLed = sp.getBool(Constants.IS_OLED_KEY);
  var isHorizontal = sp.getBool(Constants.IS_HORIZONTAL_KEY);
  var currentClockKey = sp.getString(Constants.CURRENT_CLOCK_KEY);

  var defaultBgc = sp.getInt(Constants.DEFAULT_CLOCK_BGC_KEY);
  var defaultBgo = sp.getDouble(Constants.DEFAULT_CLOCK_BGO_KEY);
  var defaultTc = sp.getInt(Constants.DEFAULT_CLOCK_TC_KEY);
  var defaultTo = sp.getDouble(Constants.DEFAULT_CLOCK_TO_KEY);
  var defaultCc = sp.getInt(Constants.DEFAULT_CLOCK_CC_KEY);
  var defaultCo = sp.getDouble(Constants.DEFAULT_CLOCK_CO_KEY);
  var isShowSed = sp.getBool(Constants.IS_SHOW_SED_KEY);
  var colorWithTheme = sp.getBool(Constants.DEFAULT_CLOCK_COLOR_WITH_THEME_KEY);

  setting.init(
      isInit: isInit,
      isFullScreen: isFullScreen,
      isOLed: isOLed,
      isHorizontal: isHorizontal,
      currentClockKey: currentClockKey,
      dFBackgroundColor: defaultBgc,
      dFBackgroundOpacity: defaultBgo,
      dFTextColor: defaultTc,
      dFTextOpacity: defaultTo,
      dFCardColor: defaultCc,
      dFCardOpacity: defaultCo,
      isShowSed: isShowSed,
      colorWithTheme: colorWithTheme);
  var providers = Providers();
  providers..provide(Provider<Setting>.value(setting));

  runApp(ProviderNode(
    child: RestartWidget(
      child: MyApp(),
    ),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final setting = Provide.value<Setting>(context);

    return MaterialApp(
      title: 'Fishing Time',
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightThemeData.copyWith(
        platform: TargetPlatform.android,
      ),
      darkTheme: AppThemeData.darkThemeData.copyWith(
        platform: TargetPlatform.android,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: false);
    return Scaffold(
      body: MainPageController(),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
