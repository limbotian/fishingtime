import 'package:flutter/material.dart';

class SettingCardItem extends StatelessWidget {
  final Widget child;

  const SettingCardItem({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsetsDirectional.fromSTEB(32, 4, 32, 4),
        child: Material(
          child: child,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).colorScheme.secondary,
        ));
  }
}
