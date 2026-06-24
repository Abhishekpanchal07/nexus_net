

/// Per-request configuration options.
///
/// These options override the global configuration
/// defined in [NetworkConfig] for a specific request.
///
/// Example:
/// ```dart
/// await api.get(
///   '/profile',
///   options: const NetworkRequestOptions(
///     requiresAuth: true,
///   ),
/// );
/// ```
class NetworkRequestOptions {
  const NetworkRequestOptions({
    this.requiresAuth = true,
    this.retryOnFailure = true,
   
    this.tag,
    this.additionalHeaders,
    this.connectTimeout,
    this.receiveTimeout,
    this.sendTimeout,
  });

  /// Whether authentication headers should be attached.
  ///
  /// Defaults to `true`.
  ///
  /// Example:
  /// ```dart
  /// NetworkRequestOptions(
  ///   requiresAuth: false,
  /// )
  /// ```
  final bool requiresAuth;

  /// Whether failed requests should be retried.
  ///
  /// Defaults to `true`.
  final bool retryOnFailure;

 
  /// Optional request tag.
  ///
  /// Can be used later for grouped request cancellation.
  ///
  /// Example:
  /// ```dart
  /// tag: 'profile'
  /// ```
  final String? tag;

  /// Additional headers for this request only.
  ///
  /// These headers are merged with:
  ///
  /// 1. Global headers
  /// 2. Authentication headers
  ///
  /// Request-specific headers always take precedence.
  ///
  /// Example:
  /// ```dart
  /// additionalHeaders: {
  ///   'Tenant-Id': '123',
  /// }
  /// ```
  final Map<String, String>? additionalHeaders;

  /// Overrides the global connect timeout
  /// for this request.
  final Duration? connectTimeout;

  /// Overrides the global receive timeout
  /// for this request.
  final Duration? receiveTimeout;

  /// Overrides the global send timeout
  /// for this request.
  final Duration? sendTimeout;

  /// Returns default request options.
  static const empty = NetworkRequestOptions();
}