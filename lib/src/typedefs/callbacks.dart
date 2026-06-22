/// Provides the current access token.
///
/// Return null if no access token exists.
typedef AccessTokenProvider = Future<String?> Function();

/// Provides the current refresh token.
///
/// Return null if no refresh token exists.
typedef RefreshTokenProvider = Future<String?> Function();

/// Called when new tokens are received after a successful refresh.
///
/// Implementers should persist the new tokens.
typedef TokenSaver = Future<void> Function({
  required String accessToken,
  required String refreshToken,
});

/// Called when the user's session has expired
/// and re-authentication is required.
typedef SessionExpiredCallback = Future<void> Function();

/// Global network error callback.
///
/// Useful for logging, analytics, crash reporting,
/// or displaying custom UI messages.
typedef ErrorCallback = void Function(
  Object error,
  StackTrace? stackTrace,
);

/// Called when a request starts.
typedef RequestStartedCallback = void Function(
  String endpoint,
);

/// Called when a request completes successfully.
typedef RequestCompletedCallback = void Function(
  String endpoint,
  int? statusCode,
);

/// Called when slow network conditions are detected.
typedef SlowNetworkCallback = void Function(
  Duration requestDuration,
);

/// Custom logger callback.
///
/// Allows package consumers to plug in their own logger.
typedef LoggerCallback = void Function(
  String message,
);

/// Called before a token refresh request is executed.
typedef TokenRefreshStartedCallback = void Function();

/// Called after a successful token refresh.
typedef TokenRefreshSuccessCallback = void Function();

/// Called when token refresh fails.
typedef TokenRefreshFailedCallback = void Function(
  Object error,

  
);
/// Allows custom headers.
typedef AuthHeadersBuilder =
    Future<Map<String, String>> Function();
    typedef ResponseParser<T> = T Function(
  dynamic data,
);