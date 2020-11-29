import 'package:fishingtime/constants.dart';
import 'package:fishingtime/pages/default_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingUtil {
  static void initDefaultSetting(SharedPreferences sp) {
    //sp.setBool(Constants.IS_INITED_KEY, Constants.IS_INITED_VAL);
    sp.setBool(Constants.IS_FULL_SCREEN_KEY, Constants.IS_FULL_SCREEN_VAL);
    sp.setBool(Constants.IS_OLED_KEY, Constants.IS_OLED_VAL);
    sp.setBool(Constants.IS_HORIZONTAL_KEY, Constants.IS_HORIZONTAL_VAL);
    sp.setString(Constants.CURRENT_CLOCK_KEY, DefaultClock.KEY);
    sp.setInt(Constants.DEFAULT_CLOCK_BGC_KEY, Constants.DEFAULT_CLOCK_BGC_VAL);
    sp.setDouble(
        Constants.DEFAULT_CLOCK_BGO_KEY, Constants.DEFAULT_CLOCK_BGO_VAL);
    sp.setInt(Constants.DEFAULT_CLOCK_TC_KEY, Constants.DEFAULT_CLOCK_TC_VAL);
    sp.setDouble(
        Constants.DEFAULT_CLOCK_TO_KEY, Constants.DEFAULT_CLOCK_TO_VAL);
    sp.setInt(Constants.DEFAULT_CLOCK_CC_KEY, Constants.DEFAULT_CLOCK_CC_VAL);
    sp.setDouble(
        Constants.DEFAULT_CLOCK_CO_KEY, Constants.DEFAULT_CLOCK_CO_VAL);
    sp.setBool(Constants.IS_SHOW_SED_KEY, Constants.IS_SHOW_SED_VAL);
    sp.setBool(Constants.DEFAULT_CLOCK_COLOR_WITH_THEME_KEY,
        Constants.DEFAULT_CLOCK_COLOR_WITH_THEME_VAL);
    sp.setBool(Constants.IS_SHOW_DOT_KEY, Constants.IS_SHOW_DOT_VAL);
    sp.setString(Constants.DEFAULT_CLOCK_FONT_FAMILY_KEY,
        Constants.DEFAULT_CLOCK_FONT_FAMILY_VALUE);
    sp.setString(Constants.CUST_TEXT_KEY, Constants.CUST_TEXT_VAL);
    sp.setBool(Constants.IS_SHOW_DATE_KEY, Constants.IS_SHOW_DATE_VAL);
  }
}
