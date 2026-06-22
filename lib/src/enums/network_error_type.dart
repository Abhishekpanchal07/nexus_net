/// Represents the type of network failure.
///
/// This enum provides a platform-independent way
/// to identify errors without relying solely on
/// HTTP status codes.
enum NetworkErrorType {
  /// No internet connection available.
  noInternet,

  /// Connection establishment timed out.
  connectionTimeout,

  /// Response was not received within timeout duration.
  requestTimeout,

  /// Authentication failed.
  unauthorized,

  /// User is authenticated but lacks permission.
  forbidden,

  /// Requested resource was not found.
  notFound,

  /// Internal server error.
  serverError,

  /// Unexpected or unclassified error.
  unknown,
}