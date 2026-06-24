/// Represents refreshed authentication tokens.
class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
  });

  /// Newly issued access token.
  final String accessToken;

  /// Newly issued refresh token.
  final String refreshToken;
}