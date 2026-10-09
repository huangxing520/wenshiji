import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/constants/api_constants.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;
  late Dio _dio;
  bool _isInitialized = false;

  HttpUtil._internal();

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await AppLogger().init();
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

    // PrettyDioLogger 仅在 debug 模式启用，避免 release 构建泄露请求/响应体。
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: false,
          logPrint: (object) {
            // 自定义日志输出：写入文件 sink
            if (object is String) {
              AppLogger().write(object);
            } else {
              AppLogger().write(object.toString());
            }
          },
        ),
      );
    }

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
    bool isNetworkError = false;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMsg = '连接超时，请检查网络';
        isNetworkError = true;
        break;
      case DioExceptionType.sendTimeout:
        errorMsg = '发送超时，请稍后重试';
        isNetworkError = true;
        break;
      case DioExceptionType.receiveTimeout:
        errorMsg = '接收超时，请稍后重试';
        isNetworkError = true;
        break;
      case DioExceptionType.connectionError:
        errorMsg = '网络连接失败，请检查网络';
        isNetworkError = true;
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

    // 只记录 path（不含 query 参数）：部分请求 URL 的 query 含设备标识（如头像 seed）。
    AppLogger().error(
      'HTTP ${e.requestOptions.method} ${e.requestOptions.uri.path} failed: $errorMsg',
      error: e.error ?? e,
      stack: e.stackTrace,
    );

    if (isNetworkError) {
      HyperSnackbar.show(
        title: '网络错误',
        message: errorMsg,
        backgroundColor: const Color(0xFFE04040),
        enterAnimationType: HyperSnackAnimationType.scale,
        enterCurve: Curves.easeOut,
        enterAnimationDuration: const Duration(milliseconds: 400),
        displayDuration: const Duration(milliseconds: 2000),
        maxWidth: 320,
      );
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
    // 类型参数用 dynamic：调用方可能以 ResponseType.bytes 取二进制（T = List<int>），
    // 若写死 Map<String, dynamic> 会在 Dio 的 assureResponse<T> 中强转失败。
    final response = await _dio.get<dynamic>(
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

}

final httpUtil = HttpUtil();
