/// Simple in-memory storage used only
/// by the example application.
///
/// Replace this with your preferred
/// secure storage solution in production.
class DemoStorage {
  String? _accessToken;

  String? _refreshToken;

  Future<String?> getAccessToken() async {
    return _accessToken;
  }

  Future<String?> getRefreshToken() async {
    return _refreshToken;
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
  }
}