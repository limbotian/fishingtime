import 'package:fishingtime/constants.dart';
import 'package:fishingtime/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';

class Setting with ChangeNotifier {
  bool _isInit;
  bool _isFullScreen;
  bool _isOLed;
  bool _isHorizontal;
  String _currentClockKey;

  //DefaultClock
  int _dFBackgroundColor;
  double _dFBackgroundOpacity;
  int _dFTextColor;
  double _dFTextOpacity;
  int _dFCardColor;
  double _dFCardOpacity;
  bool _isShowSed;
  bool _colorWithTheme;
  bool _showDot;
  String _dFClockFontFamily;
  bool _isShowDate;
  String _custText;

  init(
      {isInit,
      isFullScreen,
      isOLed,
      currentClockKey,
      dFBackgroundColor,
      dFBackgroundOpacity,
      dFTextColor,
      dFTextOpacity,
      dFCardColor,
      dFCardOpacity,
      isHorizontal,
      isShowSed,
      colorWithTheme,
      showDot,
      defaultClockFontFamily,
      isShowDate,
      custText}) {
    _isInit = isInit;
    _isFullScreen = isFullScreen;
    _isOLed = isOLed;
    _currentClockKey = currentClockKey;
    _dFBackgroundColor = dFBackgroundColor;
    _dFBackgroundOpacity = dFBackgroundOpacity;
    _dFTextColor = dFTextColor;
    _dFTextOpacity = dFTextOpacity;
    _dFCardColor = dFCardColor;
    _dFCardOpacity = dFCardOpacity;
    _isHorizontal = isHorizontal;
    _isShowSed = isShowSed;
    _colorWithTheme = colorWithTheme;
    _showDot = showDot;
    _dFClockFontFamily = defaultClockFontFamily;
    _isShowDate = isShowDate;
    _custText = custText;
  }

  bool get isShowDate => _isShowDate;

  set isShowDate(bool value) {
    _isShowDate = value;
    SharedPreferencesUtil.saveData<bool>(Constants.IS_SHOW_DATE_KEY, value);
    notifyListeners();
  }

  String get custText => _custText;

  set custText(String value) {
    _custText = value;
    SharedPreferencesUtil.saveData<String>(Constants.CURRENT_CLOCK_KEY, value);
    notifyListeners();
  }

  String get dFClockFontFamily => _dFClockFontFamily;

  set dFClockFontFamily(String value) {
    _dFClockFontFamily = value;
    SharedPreferencesUtil.saveData<String>(
        Constants.DEFAULT_CLOCK_FONT_FAMILY_KEY, value);
    notifyListeners();
  }

  bool get showDot => _showDot;

  set showDot(bool value) {
    _showDot = value;
    SharedPreferencesUtil.saveData<bool>(Constants.IS_SHOW_DOT_KEY, value);
    notifyListeners();
  }

  bool get colorWithTheme => _colorWithTheme;

  set colorWithTheme(bool value) {
    _colorWithTheme = value;
    SharedPreferencesUtil.saveData<bool>(
        Constants.DEFAULT_CLOCK_COLOR_WITH_THEME_KEY, value);
    notifyListeners();
  }

  bool get isShowSed => _isShowSed;

  set isShowSed(bool value) {
    _isShowSed = value;
    SharedPreferencesUtil.saveData<bool>(Constants.IS_SHOW_SED_KEY, value);
    notifyListeners();
  }

  double get dFBackgroundOpacity => _dFBackgroundOpacity;

  set dFBackgroundOpacity(double value) {
    _dFBackgroundOpacity = value;
    SharedPreferencesUtil.saveData<double>(
        Constants.DEFAULT_CLOCK_BGO_KEY, value);
    notifyListeners();
  }

  bool get isHorizontal => _isHorizontal;

  set isHorizontal(bool value) {
    _isHorizontal = value;
    SharedPreferencesUtil.saveData<bool>(Constants.IS_HORIZONTAL_KEY, value);
    notifyListeners();
  }

  bool get isInit => _isInit;

  set isInit(bool value) {
    _isInit = value;
    SharedPreferencesUtil.saveData<bool>(Constants.IS_INITED_KEY, value);
    notifyListeners();
  }

  bool get isFullScreen => _isFullScreen;

  set isFullScreen(bool value) {
    _isFullScreen = value;
    SharedPreferencesUtil.saveData<bool>(Constants.IS_FULL_SCREEN_KEY, value);
    notifyListeners();
  }

  String get currentClockKey => _currentClockKey;

  set currentClockKey(String value) {
    _currentClockKey = value;
    SharedPreferencesUtil.saveData<String>(Constants.CURRENT_CLOCK_KEY, value);
    notifyListeners();
  }

  bool get isOLed => _isOLed;

  set isOLed(bool value) {
    _isOLed = value;
    SharedPreferencesUtil.saveData<bool>(Constants.IS_OLED_KEY, value);
    notifyListeners();
  }

  int get dFCardColor => _dFCardColor;

  set dFCardColor(int value) {
    _dFCardColor = value;
    SharedPreferencesUtil.saveData<int>(Constants.DEFAULT_CLOCK_CC_KEY, value);
    notifyListeners();
  }

  int get dFTextColor => _dFTextColor;

  set dFTextColor(int value) {
    _dFTextColor = value;
    SharedPreferencesUtil.saveData<int>(Constants.DEFAULT_CLOCK_TC_KEY, value);
    notifyListeners();
  }

  int get dFBackgroundColor => _dFBackgroundColor;

  set dFBackgroundColor(int value) {
    _dFBackgroundColor = value;
    SharedPreferencesUtil.saveData<int>(Constants.DEFAULT_CLOCK_BGC_KEY, value);
    notifyListeners();
  }

  double get dFTextOpacity => _dFTextOpacity;

  set dFTextOpacity(double value) {
    _dFTextOpacity = value;
    SharedPreferencesUtil.saveData<double>(
        Constants.DEFAULT_CLOCK_TO_KEY, value);
    notifyListeners();
  }

  double get dFCardOpacity => _dFCardOpacity;

  set dFCardOpacity(double value) {
    _dFCardOpacity = value;
    SharedPreferencesUtil.saveData<double>(
        Constants.DEFAULT_CLOCK_CO_KEY, value);
    notifyListeners();
  }
}
