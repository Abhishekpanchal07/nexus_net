import 'package:dio/dio.dart';

import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import '../interceptors/retry_interceptor.dart';
import 'network_config.dart';

class NexusClient {
  NexusClient._();

  static late final Dio _dio;
  static late final NetworkConfig _config;

  static bool _isInitialized = false;

  static Dio get dio {
    _ensureInitialized();
    return _dio;
  }

  static NetworkConfig get config {
    _ensureInitialized();
    return _config;
  }

  static Future<void> initialize({
    required NetworkConfig config,
  }) async {
   if (_isInitialized) {
  throw StateError(
    'NexusClient has already been initialized.',
  );
}
_validateConfig(config);

    _config = config;

    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        sendTimeout: config.sendTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: config.defaultHeaders,
      ),
    );
   // Register package interceptors
  _registerInterceptors();
    _isInitialized = true;
  }

  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'NexusClient is not initialized. Call NexusClient.initialize() first.',
      );
    }
  }

  static void _validateConfig(
  NetworkConfig config,
) {
  final hasTokenManager =
      config.tokenManager != null;

  final hasRefreshEndpoint =
      config.refreshEndpoint != null &&
      (config.refreshEndpoint?.isNotEmpty ?? false);

  if (hasTokenManager && !hasRefreshEndpoint) {
    throw ArgumentError(
      'refreshEndpoint is required when tokenManager is provided.',
    );
  }

  if (!hasTokenManager && hasRefreshEndpoint) {
    throw ArgumentError(
      'tokenManager is required when refreshEndpoint is provided.',
    );
  }
}
static void _registerInterceptors() {
  _dio.interceptors.addAll([
    AuthInterceptor(),
    LoggingInterceptor(),
     RetryInterceptor(),
    // RefreshTokenInterceptor(),
  ]);
}
}