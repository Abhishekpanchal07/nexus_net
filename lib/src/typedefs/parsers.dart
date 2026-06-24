import '../models/token_pair.dart';

/// Converts refresh API response into TokenPair.
///
/// Example:
///
/// refreshTokenParser: (data) {
///   return TokenPair(
///     accessToken: data['access_token'],
///     refreshToken: data['refresh_token'],
///   );
/// }
typedef RefreshTokenParser = TokenPair Function(
  dynamic responseData,
);

typedef RefreshRequestBodyBuilder =
    Map<String, dynamic> Function(
  String refreshToken,
);