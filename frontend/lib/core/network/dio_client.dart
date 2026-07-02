import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../flavor/app_flavor.dart';
import 'api_logging_interceptor.dart';

class DioClient {
  DioClient({required AppFlavor flavor, required Logger logger})
    : dio = Dio(
        BaseOptions(
          baseUrl: flavor.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 30),
          headers: const {
            'Accept': 'application/json',
          },
        ),
      ) {
    dio.interceptors.add(ApiLoggingInterceptor(logger));
  }

  final Dio dio;
}
