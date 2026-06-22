import '../enums/network_error_type.dart';

/// Represents a network-related exception thrown by NexusNet.
///
/// This exception provides:
/// - Human-readable error messages
/// - HTTP status codes (when available)
/// - Categorized error types
/// - Optional internal error codes
///
/// Example:
/// ```dart
/// try {
///   await api.get('/profile');
/// } on NetworkException catch (e) {
///   if (e.type == NetworkErrorType.unauthorized) {
///     // Navigate user to login screen
///   }
/// }
/// ```
class NetworkException implements Exception {
  const NetworkException({
    required this.message,
    required this.type,
    this.statusCode,
    this.code,
  });

  /// Human-readable error message.
  final String message;

  /// Categorized network error type.
  final NetworkErrorType type;

  /// HTTP status code returned by the server.
  ///
  /// May be null for connectivity-related failures.
  final int? statusCode;

  /// Optional application-specific error code.
  final String? code;

  @override
  String toString() {
    return '''
NetworkException(
  type: $type,
  statusCode: $statusCode,
  code: $code,
  message: $message,
)
''';
  }

  /// Creates an unauthorized exception (401).
  factory NetworkException.unauthorized({
    String message = 'Unauthorized',
  }) {
    return NetworkException(
      message: message,
      statusCode: 401,
      type: NetworkErrorType.unauthorized,
    );
  }

  /// Creates a request timeout exception.
  factory NetworkException.timeout({
    String message = 'Request timed out',
  }) {
    return NetworkException(
      message: message,
      statusCode: 408,
      type: NetworkErrorType.requestTimeout,
    );
  }

  /// Creates a connection timeout exception.
  ///
  /// This occurs when a connection to the server
  /// cannot be established within the configured timeout.
  factory NetworkException.connectionTimeout({
    String message = 'Connection timed out',
  }) {
    return NetworkException(
      message: message,
      type: NetworkErrorType.connectionTimeout,
    );
  }

  /// Creates a no internet connection exception.
  factory NetworkException.noInternet({
    String message = 'No internet connection',
  }) {
    return NetworkException(
      message: message,
      type: NetworkErrorType.noInternet,
    );
  }

  /// Creates an internal server error exception (500).
  factory NetworkException.serverError({
    String message = 'Internal server error',
  }) {
    return NetworkException(
      message: message,
      statusCode: 500,
      type: NetworkErrorType.serverError,
    );
  }

  /// Creates an exception from an HTTP status code.
  factory NetworkException.fromStatusCode({
    required int statusCode,
    required String message,
    String? code,
  }) {
    return NetworkException(
      message: message,
      statusCode: statusCode,
      code: code,
      type: _mapStatusCode(statusCode),
    );
  }

  /// Maps HTTP status codes to [NetworkErrorType].
  static NetworkErrorType _mapStatusCode(
    int statusCode,
  ) {
    switch (statusCode) {
      case 401:
        return NetworkErrorType.unauthorized;

      case 403:
        return NetworkErrorType.forbidden;

      case 404:
        return NetworkErrorType.notFound;

      case 408:
        return NetworkErrorType.requestTimeout;

      case 500:
        return NetworkErrorType.serverError;

      default:
        return NetworkErrorType.unknown;
    }
  }
}