import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wenshiji/common/log.dart';
import 'package:wenshiji/constants/api_constants.dart';
import 'package:wenshiji/models/github_release.dart';

import '../models/weather.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;
  late Dio _dio;
  bool _isInitialized = false;

  HttpUtil._internal();

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await LogWriter().init();
      _init();
      _isInitialized = true;
    }
  }

  void _init() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: false,
        logPrint: (object) {
          // 🔥 关键：自定义日志输出
          if (object is String) {
            LogWriter().write(object); // 写入文件
          } else {
            LogWriter().write(object.toString()); // 处理非字符串类型
          }
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          _handleResponse(response, handler);
        },
        onError: (DioException e, handler) {
          _handleError(e, handler);
        },
      ),
    );
  }

  void _handleResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode;
    if (statusCode != null && (statusCode < 200 || statusCode >= 300)) {
      final errorMsg = _getErrorMessage(response);
      final error = DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: errorMsg,
      );
      handler.reject(error, true);
    } else {
      handler.next(response);
    }
  }

  void _handleError(DioException e, ErrorInterceptorHandler handler) {
    String errorMsg;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMsg = '连接超时，请检查网络';
        break;
      case DioExceptionType.sendTimeout:
        errorMsg = '发送超时，请稍后重试';
        break;
      case DioExceptionType.receiveTimeout:
        errorMsg = '接收超时，请稍后重试';
        break;
      case DioExceptionType.connectionError:
        errorMsg = '网络连接失败，请检查网络';
        break;
      case DioExceptionType.badResponse:
        errorMsg = _getErrorMessage(e.response);
        break;
      case DioExceptionType.cancel:
        errorMsg = '请求已取消';
        break;
      default:
        errorMsg = e.message ?? '请求失败，请稍后重试';
    }

    final error = DioException(
      requestOptions: e.requestOptions,
      response: e.response,
      type: e.type,
      message: errorMsg,
      error: e.error,
    );

    handler.reject(error);
  }

  String _getErrorMessage(Response? response) {
    if (response == null) {
      return '请求失败';
    }

    final statusCode = response.statusCode;
    final data = response.data;

    String msg;
    if (data is Map && data.containsKey('message')) {
      msg = data['message'] as String;
    } else if (data is Map && data.containsKey('msg')) {
      msg = data['msg'] as String;
    } else {
      msg = _getStatusMessage(statusCode);
    }

    return msg;
  }

  String _getStatusMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '拒绝访问';
      case 404:
        return '请求资源不存在';
      case 408:
        return '请求超时';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      case 504:
        return '网关超时';
      default:
        return '请求失败 (HTTP $statusCode)';
    }
  }

  Future<T> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      url,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    if (decoder != null) {
      return decoder(response.data);
    }

    return response.data as T;
  }

  // 对外暴露的POST请求
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<WeatherResponse> fetchWeather(
    double latitude,
    double longitude,
  ) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=temperature_2m&timezone=Asia/Shanghai';

    final data = await get<Map<String, dynamic>>(url);
    return WeatherResponse.fromJson(data);
  }

  Future<String?> getLatestReleaseVersion(String owner, String repo) async {
    final data = await get<GithubRelease>(
      'https://api.github.com/repos/$owner/$repo/releases/latest',
      decoder: (json) => GithubRelease.fromJson(json),
    );
    return data.tagName;
  }
}

final httpUtil = HttpUtil();
