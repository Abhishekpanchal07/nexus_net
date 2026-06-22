import 'package:dio/dio.dart';

import '../client/nexus_client.dart';
import '../enums/http_method.dart';
import '../enums/network_error_type.dart';
import '../exceptions/network_exception.dart';
import '../models/api_response.dart';
import '../models/network_request_options.dart';
import '../utils/network_constants.dart';

/// Core networking service responsible for executing
/// HTTP requests through Dio.
///
/// Responsibilities:
/// - Execute HTTP requests
/// - Apply request-specific options
/// - Convert Dio exceptions into NetworkException
/// - Return raw response data
///
/// Non-responsibilities:
/// - Model parsing
/// - UI handling
/// - State management
/// - Business logic
class ApiService {
  const ApiService();

  /// Executes a GET request.
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
  }) {
    return _request(
      method: HttpMethod.get,
      endpoint: endpoint,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Executes a POST request.
  Future<ApiResponse> post(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
  }) {
    return _request(
      method: HttpMethod.post,
      endpoint: endpoint,
      body: body,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Executes a PUT request.
  Future<ApiResponse> put(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
  }) {
    return _request(
      method: HttpMethod.put,
      endpoint: endpoint,
      body: body,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Executes a PATCH request.
  Future<ApiResponse> patch(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
  }) {
    return _request(
      method: HttpMethod.patch,
      endpoint: endpoint,
      body: body,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Executes a DELETE request.
  Future<ApiResponse> delete(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
  }) {
    return _request(
      method: HttpMethod.delete,
      endpoint: endpoint,
      body: body,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Internal request executor used by all HTTP methods.
  Future<ApiResponse> _request({
    required HttpMethod method,
    required String endpoint,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
  }) async {
    try {
      final requestOptions = options ?? const NetworkRequestOptions();

      final response = await NexusClient.dio.request(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        cancelToken: requestOptions.cancelToken,
        options: Options(
          method: _resolveHttpMethod(method),

          headers: requestOptions.additionalHeaders,

          extra: {NetworkConstants.authRequired: requestOptions.requiresAuth,NetworkConstants.retryCount: 0,

  NetworkConstants.retryOnFailure:
      requestOptions.retryOnFailure,},

          sendTimeout: requestOptions.sendTimeout,
          receiveTimeout: requestOptions.receiveTimeout,
        ),
      );

      return ApiResponse(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        headers: Map<String, List<String>>.from(response.headers.map),
      );
    } on DioException catch (error, stackTrace) {
      NexusClient.config.onError?.call(error, stackTrace);

      throw _mapDioException(error);
    }
  }

  /// Maps package HTTP method enum to
  /// Dio-compatible HTTP method string.
  String _resolveHttpMethod(HttpMethod method) {
    switch (method) {
      case HttpMethod.get:
        return 'GET';

      case HttpMethod.post:
        return 'POST';

      case HttpMethod.put:
        return 'PUT';

      case HttpMethod.patch:
        return 'PATCH';

      case HttpMethod.delete:
        return 'DELETE';
    }
  }

  /// Converts Dio exceptions into
  /// package-specific NetworkException instances.
  NetworkException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException.connectionTimeout();

      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException.timeout();

      case DioExceptionType.connectionError:
        return NetworkException.noInternet();

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled',
          type: NetworkErrorType.unknown,
        );

      case DioExceptionType.badResponse:
        return NetworkException.fromStatusCode(
          statusCode: error.response?.statusCode ?? 500,
          message: _extractMessage(error.response?.data),
        );

      default:
        return NetworkException.serverError(
          message: error.message ?? 'An unexpected error occurred.',
        );
    }
  }

  /// Attempts to extract a meaningful error
  /// message from the server response.
  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'] ?? data['detail'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    return 'Something went wrong';
  }
}
