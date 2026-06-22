import '../auth/token_manager.dart';

import '../auth/auth_provider.dart';
import '../typedefs/callbacks.dart';

class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,

    // Authentication
    this.authProvider,
    this.tokenManager,
    this.refreshEndpoint,

    // Timeouts
    this.connectTimeout = const Duration(seconds: 20),
    this.receiveTimeout = const Duration(seconds: 20),
    this.sendTimeout = const Duration(seconds: 20),

    // Retry Configuration
    this.maxRetryAttempts = 3,
    this.retryDelay = const Duration(seconds: 1),

    // Logging
    this.enableLogs = false,
    this.logger,

    // Global Callbacks
    this.onError,
    this.onSlowNetwork,
    this.onRequestStarted,
    this.onRequestCompleted,

    // Refresh Token Lifecycle
    this.onTokenRefreshStarted,
    this.onTokenRefreshSuccess,
    this.onTokenRefreshFailed,

    // Headers
    this.defaultHeaders = const {},

    // Connectivity
    this.enableConnectivityCheck = true,
  });

  /// Base API URL
  final String baseUrl;

  // ==========================
  // Authentication
  // ==========================

 final AuthProvider? authProvider;
final TokenManager? tokenManager;

  /// Example:
  /// /auth/refresh-token
  final String? refreshEndpoint;

  // ==========================
  // Timeouts
  // ==========================

  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  // ==========================
  // Retry
  // ==========================

  final int maxRetryAttempts;
  final Duration retryDelay;

  // ==========================
  // Logging
  // ==========================

  final bool enableLogs;
  final LoggerCallback? logger;

  // ==========================
  // Global Callbacks
  // ==========================

  final ErrorCallback? onError;

  final SlowNetworkCallback? onSlowNetwork;

  final RequestStartedCallback? onRequestStarted;

  final RequestCompletedCallback? onRequestCompleted;

  // ==========================
  // Refresh Token Lifecycle
  // ==========================

  final TokenRefreshStartedCallback? onTokenRefreshStarted;

  final TokenRefreshSuccessCallback? onTokenRefreshSuccess;

  final TokenRefreshFailedCallback? onTokenRefreshFailed;

  // ==========================
  // Headers
  // ==========================

  final Map<String, String> defaultHeaders;

  // ==========================
  // Connectivity
  // ==========================

  final bool enableConnectivityCheck;


  bool get isTokenRefreshEnabled {
  return tokenManager != null &&
      refreshEndpoint != null &&
      (refreshEndpoint?.isNotEmpty ?? false);
}
}