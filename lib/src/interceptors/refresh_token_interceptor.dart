import 'dart:async';

import 'package:dio/dio.dart';

import '../client/nexus_client.dart';
import '../utils/network_constants.dart';

class RefreshTokenInterceptor extends Interceptor {
  bool _isRefreshing = false;

  Completer<void>? _refreshCompleter;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Ignore non-401 errors.
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Prevent infinite loops by skipping refresh requests themselves.
    final bool skipRefresh =
        err.requestOptions.extra[NetworkConstants.skipRefreshToken] as bool? ??
        false;

    if (skipRefresh) {
      handler.next(err);
      return;
    }

    // Refresh functionality is disabled.
    if (!NexusClient.config.isTokenRefreshEnabled) {
      handler.next(err);
      return;
    }

    // Another request is already refreshing the token.
    if (_isRefreshing) {
      try {
        // Wait until the current refresh finishes.
        await _refreshCompleter?.future;

        // Retry original request with fresh token.
        final response = await NexusClient.dio.fetch(err.requestOptions);

        handler.resolve(response);
      } catch (_) {
        handler.next(err);
      }

      return;
    }

    // First request enters refresh flow.
    _isRefreshing = true;

    _refreshCompleter = Completer<void>();

    try {
      // Refresh access token.
      await _refreshAccessToken();

      // Wake up all waiting requests.
      _refreshCompleter?.complete();

      // Retry original request.
      final response = await NexusClient.dio.fetch(err.requestOptions);

      handler.resolve(response);
    } catch (error) {
      // Notify waiting requests that refresh failed.
      _refreshCompleter?.completeError(error);

      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  /// Refreshes expired authentication tokens.
  Future<void> _refreshAccessToken() async {
    final tokenManager = NexusClient.config.tokenManager!;

    final refreshToken = await tokenManager.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await tokenManager.onSessionExpired();

      throw StateError('Refresh token not found.');
    }
    final refreshEndpoint = NexusClient.config.refreshEndpoint;
    if (refreshEndpoint == null || refreshToken.isEmpty) {
      await tokenManager.onSessionExpired();

      throw StateError('Refresh endpoint not found.');
    }

    NexusClient.config.onTokenRefreshStarted?.call();

    try {
      // Create isolated Dio instance to avoid
      // interceptor recursion.
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: NexusClient.config.baseUrl,
          connectTimeout: NexusClient.config.connectTimeout,
          sendTimeout: NexusClient.config.sendTimeout,
          receiveTimeout: NexusClient.config.receiveTimeout,
          headers: NexusClient.config.defaultHeaders,
        ),
      );

      final requestBody =
          NexusClient.config.refreshRequestBodyBuilder?.call(refreshToken) ??
          {'refresh_token': refreshToken};

      final response = await refreshDio.post(
        NexusClient.config.refreshEndpoint ?? "",
        data: requestBody,
        options: Options(
          extra: {
            NetworkConstants.skipRefreshToken: true,
            NetworkConstants.authRequired: false,
          },
        ),
      );

      final tokenPair = NexusClient.config.refreshTokenParser!(response.data);

      await tokenManager.saveTokens(
        accessToken: tokenPair.accessToken,
        refreshToken: tokenPair.refreshToken,
      );

      NexusClient.config.onTokenRefreshSuccess?.call();
    } catch (error) {
      NexusClient.config.onTokenRefreshFailed?.call(error);

      await tokenManager.onSessionExpired();

      rethrow;
    }
  }
}
