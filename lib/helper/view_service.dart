import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewServiceHelper {
  static ViewServiceHelper instance = ViewServiceHelper();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  BuildContext? scaffoldContext;
  setScaffoldContext(BuildContext context) {
    scaffoldContext = context;
  }
}