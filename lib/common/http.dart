import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wenshiji/constants/api_constants.dart';

import '../models/weather.dart'; // 请根据实际情况调整

class HttpUtil {
  // 单例模式
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;
  late Dio _dio;

  HttpUtil._internal() {
    _init();
  }

  void _init() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    ));

    // 1. 添加请求头拦截器 (携带Token)
    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     String? token = prefs.getString('token');
    //     if (token != null && token.isNotEmpty) {
    //       options.headers['Authorization'] = 'Bearer $token';
    //     }
    //     return handler.next(options);
    //   },
    // ));

    // 2. 添加日志拦截器
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false));

    // 3. 添加响应和错误拦截器 (处理401)
    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        return handler.next(e);
      },
    ));
  }

  // 对外暴露的GET请求
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    return await _dio.get(url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
  }

  // 对外暴露的POST请求
  Future<Response> post(String url,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    return await _dio.post(url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
  }

  Future<WeatherResponse> fetchWeather(double latitude, double longitude) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=temperature_2m&timezone=Asia/Shanghai';

    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final data = WeatherResponse.fromJson(response.data);
      return data;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Failed to fetch weather data',
      );
    }
  }
} 

final httpUtil = HttpUtil();
