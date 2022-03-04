import 'package:dio/dio.dart';

import '../providers/secure_storage_provider.dart';
import 'environment.dart';

class BlackBellsApi {
  static final _dio = Dio();
  static Future<void> init() async {
    _dio.options.baseUrl = Environment.config.baseURL;
    _dio.options.headers = {'x-token': await SecureStorage.getToken()};
    _dio.options.connectTimeout = 60 * 1000;
    _dio.options.receiveTimeout = 60 * 1000;
  }

  static Future<Response<dynamic>> dGet(String path) async {
    try {
      final resp = await _dio.get(path);
      return resp;
    } on DioError catch (_) {
      rethrow;
    }
  }

  static Future<Response<dynamic>> dPost(String path, {dynamic data}) async {
    try {
      final resp = await _dio.post(path, data: data);
      return resp;
    } on DioError catch (_) {
      rethrow;
    }
  }

  static Future<Response<dynamic>> dPut(String path, {dynamic data}) async {
    try {
      final resp = await _dio.put(path, data: data);
      return resp;
    } on DioError catch (_) {
      rethrow;
    }
  }

  static Future<Response<dynamic>> dDelete(String path, {dynamic data}) async {
    try {
      final resp = await _dio.delete(path, data: data);
      return resp;
    } on DioError catch (_) {
      rethrow;
    }
  }
}
