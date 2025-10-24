import 'dart:convert';
import 'dart:io';

import 'package:base_project/model/base.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:base_project/model/models.dart' as models;

class ServiceLoggerInterceptor extends InterceptorsWrapper {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');

}

abstract class BaseService {
  static String? auth;
  static late Dio client;
  static late PackageInfo info;

  static initialize(Dio newClient) async {
    client = newClient;
    info = await PackageInfo.fromPlatform();
  }

  static setAuthentication(String? token) {
    BaseService.auth = token;
    BaseService.client.options.headers =
    {'Authorization': 'Bearer $token'};
  }

  Map<String, dynamic> _createHeaders() {
    return {
      'Authorization': 'Bearer $auth',
      'Accept': 'application/json',
    };
  }

  Future<List<T?>> getAll<T extends BaseModel<T>>({String? resource,
    Map<String, dynamic>? params}) async {
    final response = await _wrapRequest(() =>
        client.get("$resource",
            queryParameters: params,
            options: Options(headers: _createHeaders())));
    return List.from(response.data).map((item) {
      return models.ModelGenerator.resolve<T>(item);
    }) as Future<List<T?>>;
  }

  Future<T?> get<T extends BaseModel<T>>(String resource,
      {Map<String, dynamic>? params}) async {
    final response = await _wrapRequest(() =>
        client.get(resource,
            queryParameters: params,
            options: Options(headers: _createHeaders())));
    return models.ModelGenerator.resolve<T>(response.data);
  }

  Future<dynamic> getRaw(String resource,
      {Map<String, dynamic>? params}) async {
    final response = await _wrapRequest(() =>
        client.get(resource,
            queryParameters: params,
            options: Options(headers: _createHeaders())));
    return response.data;
  }

  Future<dynamic> getCount(String resource,
      {Map<String, dynamic>? params,
        Map<String, dynamic>? headers = const {}}) async {
    final response = await _wrapRequest(() =>
        client.get(resource,
            queryParameters: params,
            options: Options(headers: _createHeaders()
              ..addAll(headers!))));
    return response.data;
  }

  Future<T?> post<T>(String resource, {Map<String, dynamic>? body}) async {
    final response = await _wrapRequest(() => client.post(resource,
        data: body, options: Options(headers: _createHeaders())));
    // return response.data;
    return models.ModelGenerator.resolve<T>(response.data);
  }

  Future<models.Response<T>> postResource<T extends BaseModel<T>>(
      String resource,
      {dynamic body,
        Map<String, dynamic>? queryParameters}) async {
    final response = await _wrapRequest(() => client.post(resource,
        data: body is String ? body : jsonEncode(body),
        options: Options(headers: _createHeaders()),
        queryParameters: queryParameters));
    final parsed = models.Response<T>.fromJson(response.data);
    if (!parsed.success!) {
      throw parsed.message!;
    }
    return parsed;
  }

  Future<models.Response<T>> getResource<T extends BaseModel<T>>(
      String resource,
      {Map<String, dynamic>? params,
        Map<String, dynamic>? headers = const {}}) async {
    try {
      final response = await _wrapRequest(() => client.get(resource,
          queryParameters: params,
          options: Options(headers: _createHeaders()..addAll(headers!))));
      final parsed = models.Response<T>.fromJson(response.data);
      return parsed;
    } catch (e) {
      rethrow;
    }
  }

  Future<models.Response<T>> putResource<T extends BaseModel<T>>(
      String resource,
      {Map<String, dynamic>? body}) async {
    final response = await _wrapRequest(() => client.put(resource,
        data: jsonEncode(body), options: Options(headers: _createHeaders())));
    final parsed = models.Response<T>.fromJson(response.data);
    if (!parsed.success!) {
      throw parsed.message!;
    }
    return parsed;
  }

  Future<dynamic> postRaw(String resource,
      {Map<String, dynamic>? body}) async {
    final response = await _wrapRequest(() =>
        client.post(resource,
            data: body, options: Options(headers: _createHeaders())));
    return response.data;
  }

  Future<dynamic> putRaw(String resource,
      {Map<String, dynamic>? body}) async {
    final response = await _wrapRequest(() =>
        client.put(resource,
            data: body, options: Options(headers: _createHeaders())));
    return response.data;
  }

  Future<models.Response<T>> deleteResource<T extends BaseModel<T>>(
      String resource,
      {Map<String, dynamic>? body,}) async {
    final response = await _wrapRequest(() => client.delete(
        resource,
        data: jsonEncode(body),
        options: Options(headers: _createHeaders())));
    if(!(response.data as Map<String, dynamic>).containsKey("data")) {
      return models.Response<T>();
    }
    final parsed = models.Response<T>.fromJson(response.data);
    if (!parsed.success!) {
      throw parsed.message!;
    }
    return parsed;
  }

  Future<bool> deleteRaw(String resource,
      {Map<String, dynamic>? body}) async {
    Response response = await _wrapRequest(() => client.delete(
        resource,
        data: jsonEncode(body),
        options: Options(headers: _createHeaders())));
    if(response.statusCode == 204 || response.statusCode == 200) {
      if(response.statusCode == 204){
        return true;
      }
      else {
        return response.data['success'];
      }
    } else {
      return false;
    }
  }

  _wrapRequest(request, {int retryCount = 3}) async {
    try {
      return await request();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if (retryCount == 3) {
          rethrow;
        } else {
          await Future.delayed(const Duration(seconds: 1), () {
            print('retrying request');
          });
          return _wrapRequest(request, retryCount: retryCount + 1);
        }
      }
      rethrow;
    } on SocketException catch (e) {
      if (retryCount == 3) {
        rethrow;
      } else {
        await Future.delayed(const Duration(seconds: 1), () {
          print('retrying request');
        });
        return _wrapRequest(request, retryCount: retryCount + 1);
      }
    } catch (e) {
      rethrow;
    }
  }
}