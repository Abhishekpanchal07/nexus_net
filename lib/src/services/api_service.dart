import 'package:dio/dio.dart';
import 'package:nexus_net/src/services/base_service.dart';
import '../client/nexus_client.dart';
import '../enums/http_method.dart';
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
class ApiService extends BaseService {
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
    final requestOptions = options ?? const NetworkRequestOptions();

    final cancelToken = createCancelToken(requestOptions);
    try {
      await checkConnectivity();

      final response = await NexusClient.dio.request(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(
          method: _resolveHttpMethod(method),

          headers: requestOptions.additionalHeaders,

          extra: {
            NetworkConstants.authRequired: requestOptions.requiresAuth,
            NetworkConstants.retryCount: 0,

            NetworkConstants.retryOnFailure: requestOptions.retryOnFailure,
          },

          sendTimeout: requestOptions.sendTimeout,
          receiveTimeout: requestOptions.receiveTimeout,
        ),
      );

      return mapResponse(response);
    } on DioException catch (error, stackTrace) {
      NexusClient.config.onError?.call(error, stackTrace);

      throwMappedException(error);
    } finally {
      disposeCancelToken(
  cancelToken,
  requestOptions,
);
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
}
