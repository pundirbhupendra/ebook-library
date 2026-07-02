import 'package:dio/dio.dart';

import 'failure.dart';

class ErrorMapper {
  const ErrorMapper();

  Failure map(Object error) {
    if (error is Failure) return error;
    if (error is DioException) return _mapDio(error);
    return UnknownFailure(details: error);
  }

  Failure _mapDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = _extractMessage(data);

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return NetworkFailure(code: statusCode, details: error);
    }

    if (statusCode == 422) {
      return ValidationFailure(message: message, details: data);
    }

    if (statusCode != null && statusCode >= 400) {
      return ServerFailure(
        message: message,
        code: statusCode,
        details: data,
      );
    }

    return UnknownFailure(details: error);
  }

  String _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) return errors.join(', ');
      final error = data['error'];
      if (error is String && error.isNotEmpty) return error;
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return 'Something went wrong. Please try again.';
  }
}
