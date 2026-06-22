abstract class TokenManager {
  /// Returns the refresh token used
  /// to obtain a new access token.
  Future<String?> getRefreshToken();

  /// Persist newly issued tokens.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  /// Called when refresh fails and
  /// the user must authenticate again.
  Future<void> onSessionExpired();
}