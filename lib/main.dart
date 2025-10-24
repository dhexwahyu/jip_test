import 'dart:async';
import 'package:base_project/services/base_service.dart';
import 'package:base_project/services/services.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart' as sentry;

import 'app.dart';

import 'env.dart';
import 'helper/sentry.dart';

void main() => runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client =
  Dio(
    BaseOptions(
      baseUrl: 'https://${environment['apiBaseUrl']}/api/',
    ),
  );
  client.interceptors.addAll(dioInterceptors);
  BaseService.initialize(client);
  Service.setup(client);
  runApp(App());
}, (error, stackTrace) {
  try {
    // if (error is! Exception) {
    //   Sentry.instance.sendEvent(sentry.SentryEvent(
    //     message: sentry.SentryMessage(error.toString()),
    //   ));
    // } else {
    //
    //   Sentry.instance
    //       .captureException(exception: error, stackTrace: stackTrace);
    // }
    // print('Error sent to sentry.io: $error');
     print(stackTrace);
  } catch (e) {
    print('Sending report to sentry.io failed: $e');
    print('Original error: $error');
  }
});
