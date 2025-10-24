import 'package:flutter/material.dart';

typedef ContextCallback = void Function(BuildContext context);

class BaseScreen extends StatelessWidget {
  final String? title;
  final Widget? floatingActionButton;
  final Widget? body;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? actions;
  final bool showAppBar;
  final Widget? appBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final ContextCallback? callback;
  final WidgetBuilder? builder;
  final bool appBarOverlay;
  final Widget? leading;
  final Drawer? drawer;
  final Drawer? drawerRight;
  final Color? color;
  BaseScreen(
      {this.title,
        this.drawer,
        this.drawerRight,
        this.scaffoldKey,
        this.floatingActionButton,
        this.floatingActionButtonLocation,
        this.callback,
        this.body,
        this.actions,
        this.builder,
        this.leading,
        this.appBar,
        this.color,
        this.appBarOverlay = false,
        this.showAppBar = false});
  Widget? displayAppBar() {
    return showAppBar
        ? appBar ??
        AppBar(
          leading: leading,
          automaticallyImplyLeading: leading == null,
          centerTitle: false,
          title: Title(
            color: Colors.black,
            child: Text(title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          ),
          actions: actions,
        )
        : null;
  }

  Widget? buildBody(BuildContext context) {
    final currentBody = () => builder != null ? builder!(context) : body;
    if (appBarOverlay) {
      return Stack(
        children: <Widget>[currentBody()!, displayAppBar()!],
      );
    }
    return currentBody();
  }

  @override
  Widget build(BuildContext context) {
    if (callback != null) callback!(context);
    return Scaffold(
      backgroundColor: color ?? const Color(0xFFFFFFFF),
      key: scaffoldKey ?? key,
      drawer: drawer,
      endDrawer: drawerRight,
      appBar: appBarOverlay ? null : displayAppBar() as PreferredSizeWidget?,
      body: buildBody(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      extendBody: true,
    );
  }
}