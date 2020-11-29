import 'package:fishingtime/widgets/setting_card_item.dart';
import 'package:flutter/material.dart';

void showCustModalBottomSheet(
    {BuildContext context, Widget widget, double height}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: height,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SettingCardItem(
              child: widget,
            ),
          ),
        );
      });
}
