import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'dart:core';

import 'package:vietnam_history/utils/logger_filter.dart';

class DioClient {
  static final Dio _dio = Dio();

  static var token = '';
  static final Logger _logger = Logger(
      filter: LoggerFIlter(),
      printer: PrettyPrinter(
          methodCount: 0, dateTimeFormat: DateTimeFormat.onlyTime));

  static Dio get instance {
    // Set base options
    _dio.options.baseUrl = dotenv.env["BASE_URL"] ?? '';
    _dio.options.connectTimeout = const Duration(minutes: 1); // 5 seconds
    _dio.options.receiveTimeout = const Duration(minutes: 1); // 3 seconds
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };

    _dio.interceptors.clear();

    // Add interceptors if needed
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final stopwatch = Stopwatch()..start();
        options.extra['stopwatch'] = stopwatch;
        _logger.d('Request started: ${options.method} ${options.path}');
        var storage = const FlutterSecureStorage();
        var token = await storage.read(key: 'token');
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final stopwatch =
            response.requestOptions.extra['stopwatch'] as Stopwatch;
        stopwatch.stop();
        _logger.i(
            'Request completed: ${response.statusCode} ${response.requestOptions.path} in ${stopwatch.elapsedMilliseconds} ms');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        final stopwatch = e.requestOptions.extra['stopwatch'] as Stopwatch;
        stopwatch.stop();
        _logger.e(
            'Request error: ${e.message} after ${stopwatch.elapsedMilliseconds} ms');
        return handler.next(e);
      },
    ));

    return _dio;
  }
}
