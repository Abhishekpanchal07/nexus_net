import 'dart:convert';

import 'package:dio/dio.dart';

import '../client/nexus_client.dart';

/// Logs request, response and error information.
///
/// Logging is enabled only when
/// [NetworkConfig.enableLogs] is true.
class LoggingInterceptor extends Interceptor {
  final Map<int, Stopwatch> _requestTimers = {};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (!NexusClient.config.enableLogs) {
      handler.next(options);
      return;
    }

    final stopwatch = Stopwatch()..start();
    _requestTimers[options.hashCode] = stopwatch;

    _log('''
╔════════════════ REQUEST ════════════════
${options.method} ${options.uri}

Headers:
${_prettyPrint(options.headers)}

Query Parameters:
${_prettyPrint(options.queryParameters)}

Body:
${_prettyPrint(options.data)}
╚═════════════════════════════════════════
''');

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (!NexusClient.config.enableLogs) {
      handler.next(response);
      return;
    }

    final stopwatch =
        _requestTimers.remove(response.requestOptions.hashCode);

    stopwatch?.stop();

    _log('''
╔════════════════ RESPONSE ═══════════════
${response.requestOptions.method} ${response.requestOptions.uri}

Status Code: ${response.statusCode}
Duration: ${stopwatch?.elapsedMilliseconds ?? 0} ms

Response:
${_prettyPrint(response.data)}
╚═════════════════════════════════════════
''');

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (!NexusClient.config.enableLogs) {
      handler.next(err);
      return;
    }

    final stopwatch =
        _requestTimers.remove(err.requestOptions.hashCode);

    stopwatch?.stop();

    _log('''
╔════════════════ ERROR ══════════════════
${err.requestOptions.method} ${err.requestOptions.uri}

Duration: ${stopwatch?.elapsedMilliseconds ?? 0} ms

Message:
${err.message}

Response:
${_prettyPrint(err.response?.data)}
╚═════════════════════════════════════════
''');

    handler.next(err);
  }

  void _log(String message) {
    final logger = NexusClient.config.logger;

    if (logger != null) {
      logger(message);
      return;
    }

    // fallback
    // ignore: avoid_print
    print(message);
  }

  String _prettyPrint(
    dynamic object,
  ) {
    if (object == null) {
      return 'null';
    }

    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(object);
    } catch (_) {
      return object.toString();
    }
  }
}