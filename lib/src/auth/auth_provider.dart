abstract class AuthProvider {
  /// Returns authentication headers
  /// to be attached to outgoing requests.
  Future<Map<String, String>> getHeaders();
}
