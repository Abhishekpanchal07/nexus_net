import 'package:dio/dio.dart';

/// Manages request cancellation.
///
/// Requests can be grouped by tags and cancelled
/// individually or all at once.
class CancellationManager {
  CancellationManager._();

  static final Map<String, List<CancelToken>>
      _tagTokens = {};

  static final List<CancelToken>
      _globalTokens = [];

  /// Creates and registers a token.
  static CancelToken createToken({
    String? tag,
  }) {
    final token = CancelToken();

    _globalTokens.add(token);

    if (tag != null) {
      _tagTokens.putIfAbsent(
        tag,
        () => [],
      ).add(token);
    }

    return token;
  }

  /// Cancels all requests associated with a tag.
  static void cancelTag(
    String tag, {
    String reason = 'Request cancelled.',
  }) {
    final tokens = _tagTokens[tag];

    if (tokens == null) {
      return;
    }

    for (final token in tokens) {
      if (!token.isCancelled) {
        token.cancel(reason);
      }
    }

    _tagTokens.remove(tag);
  }

  /// Cancels every active request.
  static void cancelAll({
    String reason = 'All requests cancelled.',
  }) {
    for (final token in _globalTokens) {
      if (!token.isCancelled) {
        token.cancel(reason);
      }
    }

    _globalTokens.clear();
    _tagTokens.clear();
  }

  /// Removes completed token references.
  static void removeToken(
    CancelToken token,
    String? tag,
  ) {
    _globalTokens.remove(token);

    if (tag == null) {
      return;
    }

    final tokens = _tagTokens[tag];

    if (tokens == null) {
      return;
    }

    tokens.remove(token);

    if (tokens.isEmpty) {
      _tagTokens.remove(tag);
    }
  }
}