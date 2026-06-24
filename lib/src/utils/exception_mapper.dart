import 'package:dio/dio.dart';

import '../enums/network_error_type.dart';
import '../exceptions/network_exception.dart';

/// Utility responsible for converting
/// Dio exceptions into package-specific
/// [NetworkException] instances.
class ExceptionMapper {
  const ExceptionMapper._();

  /// Maps a [DioException] to [NetworkException].
  static NetworkException fromDio(
    DioException error,
  ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException.connectionTimeout();

      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException.timeout();

      case DioExceptionType.connectionError:
        return NetworkException.noInternet();

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Request was cancelled.',
          type: NetworkErrorType.cancelled,
        );

      case DioExceptionType.badResponse:
        return NetworkException.fromStatusCode(
          statusCode:
              error.response?.statusCode ?? 500,
          message: _extractMessage(
            error.response?.data,
          ),
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return NetworkException.serverError(
          message:
              error.message ??
              'An unexpected error occurred.',
        );
    }
  }

  /// Attempts to extract a meaningful
  /// error message from response data.
  static String _extractMessage(
    dynamic data,
  ) {
    if (data is Map<String, dynamic>) {
      final message =
          data['message'] ??
          data['error'] ??
          data['detail'];

      if (message is String &&
          message.trim().isNotEmpty) {
        return message;
      }
    }

    return 'Something went wrong.';
  }
}