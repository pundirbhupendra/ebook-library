import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiLoggingInterceptor extends Interceptor {
  ApiLoggingInterceptor(this._logger);

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('${options.method} ${options.uri}');
    if (options.data != null) {
      _logger.d('Request body: ${_formatData(options.data)}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.i(
      '${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}',
    );
    _logger.i('Response body: ${_formatData(response.data)}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '${err.response?.statusCode ?? 'ERR'} ${err.requestOptions.method} '
      '${err.requestOptions.uri}',
      error: err,
    );
    if (err.response?.data != null) {
      _logger.i('Error response body: ${_formatData(err.response?.data)}');
    }
    super.onError(err, handler);
  }

  Object? _formatData(Object? data) {
    if (data is FormData) {
      return {
        'fields': Map<String, String>.fromEntries(data.fields),
        'files': data.files
            .map(
              (file) => {
                'field': file.key,
                'filename': file.value.filename,
                'contentType': file.value.contentType.toString(),
              },
            )
            .toList(),
      };
    }

    return data;
  }
}
