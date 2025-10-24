import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sentry/sentry.dart';
import 'package:universal_platform/universal_platform.dart';

const FILTER_KEYS = ['authorization'];

class Sentry {
  static Sentry instance = Sentry._singleton();
  late SentryClient client;
  List<Breadcrumb> breadcrumbs = [];
  SentryDevice? device;
  SentryOperatingSystem? system;
  SentryApp? app;
  SentryUser? user;

  Sentry._singleton() {
    client = SentryClient(
      SentryOptions(
        dsn: "insert your id sentry"));
    PackageInfo.fromPlatform().then((value) {
      app = SentryApp(
        name: value.packageName,
        version: value.version,
        build: value.buildNumber,
      );
    });
    if (UniversalPlatform.isAndroid) {
      DeviceInfoPlugin().androidInfo.then((value) {
        system = SentryOperatingSystem(
          name: value.version.codename ?? 'Android',
          build: value.version.sdkInt.toString(),
          version: value.version.release,
        );
        device = SentryDevice(
          name: value.device,
          brand: value.brand,
          arch: value.board,
          manufacturer: value.manufacturer,
          model: value.model,
          simulator: !value.isPhysicalDevice!,
        );
      });
    }
    if (UniversalPlatform.isIOS) {
      DeviceInfoPlugin().iosInfo.then((value) {
        system = SentryOperatingSystem(
          name: value.systemName,
          version: value.systemVersion,
        );
        device = SentryDevice(
          name: value.name,
          arch: value.utsname.machine,
          manufacturer: "Apple",
          model: value.model,
          simulator: !value.isPhysicalDevice,
        );
      });
    }
  }
  addBreadcrumb(Breadcrumb breadcrumb) {
    breadcrumbs.add(breadcrumb);
  }

  sendEvent(SentryEvent event) {
    client.captureEvent(
      event.copyWith(
        breadcrumbs: breadcrumbs,
        contexts: Contexts(
          device: device,
          operatingSystem: system,
          app: app,
        ),
        user: user
      ),
    );
  }

  setUser(SentryUser user) {
    this.user = user;
  }

  captureException({Exception? exception, StackTrace? stackTrace}) {
    client.captureException(exception, stackTrace: stackTrace);
    // sendEvent(SentryEvent(
    //   stackTrace: ,
    //   level: SentryLevel.error,
    // ));
  }
}

class SentryInterceptor extends Interceptor {
  @override
  Future? onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final request = super.onRequest(options, handler);
    final Map<String, String> headers =
        Map<String, String>.from((options.headers))
          ..removeWhere(
            (key, value) => FILTER_KEYS.contains(
              key.toString().toLowerCase(),
            ),
          );
    final Map<String, String> breadcrumbData = Map<String, String>();
    final encoder = JsonEncoder.withIndent(" ");
    breadcrumbData.addAll({
      "headers": encoder.convert(headers),
    });
    if ((options.queryParameters).keys.length > 0) {
      breadcrumbData.addAll({
        "params": encoder.convert(options.queryParameters),
      });
    }
    if (options.data != null) {
      breadcrumbData.addAll({
        "body": encoder.convert(options.data),
      });
    }
    Sentry.instance.addBreadcrumb(
      Breadcrumb(
        message: 'request ${options.method} ${options.uri.toString()}',
        timestamp: DateTime.now(),
        data: breadcrumbData,
        type: "api",
        category: "api",
        level: SentryLevel.info,
      ),
    );
  }

}

class SentryNavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  pushEvent(String action, String? from, String? to, {dynamic params}) {
    Sentry.instance.addBreadcrumb(
      Breadcrumb(
        message: '$action navigation',
        timestamp: DateTime.now(),
        category: action,
        type: 'navigation',
        level: SentryLevel.debug,
        data: {
          "from": from,
          "to": to,
          "argument": params.toString(),
        },
      ),
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    this.pushEvent('pop', previousRoute!.settings.name, route.settings.name);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    this.pushEvent(
        'push', previousRoute?.settings.name ?? '', route.settings.name,
        params: route.settings.arguments);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    this.pushEvent('replace', oldRoute!.settings.name, newRoute!.settings.name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    this.pushEvent('remove', previousRoute!.settings.name, route.settings.name);
    super.didRemove(route, previousRoute);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    this.pushEvent(
        'startUserGesture', previousRoute!.settings.name, route.settings.name);
    super.didStartUserGesture(route, previousRoute);
  }
}

final List<Interceptor> dioInterceptors = [
  PrettyDioLogger(
    requestHeader: false,
    requestBody: true,
    responseHeader: false,
    responseBody: false,
  ),
 // SentryInterceptor(),
];
