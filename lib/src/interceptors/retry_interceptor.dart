import 'package:dio/dio.dart';

import '../client/nexus_client.dart';
import '../utils/network_constants.dart';

/// Retries transient network failures.
///
/// Retries:
/// - Connection timeout
/// - Send timeout
/// - Receive timeout
/// - Connection errors
///
/// Does NOT retry:
/// - 400
/// - 401
/// - 403
/// - 404
/// - Request cancellation
class RetryInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;

    final bool retryOnFailure =
        requestOptions.extra[NetworkConstants.retryOnFailure]
            as bool? ??
        true;

    if (!retryOnFailure || !_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final int retryCount =
        requestOptions.extra[NetworkConstants.retryCount]
            as int? ??
        0;

    if (retryCount >= NexusClient.config.maxRetryAttempts) {
      handler.next(err);
      return;
    }

    requestOptions.extra[NetworkConstants.retryCount] =
        retryCount + 1;

    await Future.delayed(
      NexusClient.config.retryDelay,
    );

    try {
      final response = await NexusClient.dio.fetch(
        requestOptions,
      );

      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  /// Determines whether the failed request
  /// should be retried.
  bool _shouldRetry(
    DioException error,
  ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;

      default:
        return false;
    }
  }
}