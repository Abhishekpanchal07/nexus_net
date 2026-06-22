import 'package:dio/dio.dart';

import '../client/nexus_client.dart';
import '../utils/network_constants.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final bool requiresAuth =
          options.extra[NetworkConstants.authRequired] as bool? ??
              true;

      if (requiresAuth) {
        final authProvider =
            NexusClient.config.authProvider;

        if (authProvider != null) {
          final headers =
              await authProvider.getHeaders();

          options.headers.addAll(headers);
        }
      }

      if (options.data is! FormData) {
        options.headers.putIfAbsent(
          Headers.contentTypeHeader,
          () => Headers.jsonContentType,
        );
      }

      handler.next(options);
    } catch (error, stackTrace) {
      NexusClient.config.onError?.call(
        error,
        stackTrace,
      );

      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}