import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final int? code;
  final Object? details;

  @override
  List<Object?> get props => [message, code, details];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Please check your connection and try again.',
    super.code,
    super.details,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Something went wrong on the server.',
    super.code,
    super.details,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Please review the highlighted fields.',
    super.code = 422,
    super.details,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'We could not read the local library cache.',
    super.code,
    super.details,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.code,
    super.details,
  });
}
