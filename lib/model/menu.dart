import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Widget MenuInfo();
typedef List<Widget> MenuActions(BuildContext context);

class Menu {
  final String? label;
  final IconData? icon;
  final String? key;
  final MenuInfo? menuInfo;
  final Color backgroundColor;
  final Function(BuildContext)? onTap;
  final MenuActions? actions;
  final Widget? page;
  Menu(
      {this.label,
        this.icon,
        this.actions,
        this.key,
        this.menuInfo,
        this.onTap,
        this.backgroundColor = Colors.white,
        this.page});
}