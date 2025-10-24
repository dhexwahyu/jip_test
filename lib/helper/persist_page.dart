import 'package:flutter/cupertino.dart';

class PersistPage extends StatefulWidget {
  final Widget? child;
  PersistPage({this.child});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PersistPageState();
  }
}

class _PersistPageState extends State<PersistPage>
    with AutomaticKeepAliveClientMixin<PersistPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return widget.child!;
  }

  @override
  bool get wantKeepAlive => true;
}