import 'dart:async';
import 'dart:convert';

import 'package:base_project/model/base.dart';
import 'package:base_project/model/generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

class BaseStorage<T extends BaseModel<T>> {
  T? data;
  final String? identifier;
  final StreamController<T?>? streamController;
  SharedPreferences prefs;
  BaseStorage<T> setData(T? value) {
    data = value;
    if (data != null) {
      streamController?.add(data);
    }
    return this;
  }

  T? getData() => data;
  final String? path;
  get stream => streamController!.stream;
  String storageKey() {
    return T.toString();
  }

  BaseStorage({this.streamController, this.identifier, this.path, required this.prefs});

  static Future<BaseStorage<S>> resolve<S extends BaseModel<S>>() async {
    final prefs = await SharedPreferences.getInstance();
    if (UniversalPlatform.isWeb) {
      final resolved = BaseStorage(
          streamController: StreamController<S>.broadcast(),
          identifier: DateTime.now().toIso8601String(), prefs: prefs);
      await resolved.load();
      return resolved;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final resolved = BaseStorage(
          streamController: StreamController<S>.broadcast(),
          identifier: DateTime.now().toIso8601String(),
          prefs: prefs,
          path: '${directory.path}/storage/${S.toString()}.json');
      await resolved.load();
      return resolved;
    }
  }

  save() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(storageKey(), jsonEncode(data));
  }

  load() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final dataString = await prefs.getString(storageKey());
      if(dataString == null) return;
      final response = jsonDecode(dataString);
      setData(response == null ? response : ModelGenerator.resolve<T>(response));
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey());
    setData(null);
  }
}
