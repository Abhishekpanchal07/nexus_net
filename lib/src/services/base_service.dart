import 'package:dio/dio.dart';

import '../client/nexus_client.dart';
import '../exceptions/network_exception.dart';
import '../models/api_response.dart';
import '../models/network_request_options.dart';
import '../utils/response_mapper.dart';
import '../utils/exception_mapper.dart';
import 'cancellation_manager.dart';
import 'connectivity_service.dart';

abstract class BaseService {
  const BaseService();

  /// Ensures internet connectivity before
  /// executing requests.
  Future<void> checkConnectivity() async {
    if (!NexusClient.config.enableConnectivityCheck) {
      return;
    }

    final isConnected =
        await ConnectivityService.isConnected();

    if (!isConnected) {
      throw NetworkException.noInternet();
    }
  }

  /// Creates a cancel token for the request.
  CancelToken createCancelToken(
    NetworkRequestOptions options,
  ) {
    return CancellationManager.createToken(
      tag: options.tag,
    );
  }

  /// Removes internally managed token.
  void disposeCancelToken(
    CancelToken token,
    NetworkRequestOptions options,
  ) {
    CancellationManager.removeToken(
      token,
      options.tag,
    );
  }

  /// Converts Dio response into ApiResponse.
  ApiResponse mapResponse(
    Response response,
  ) {
    return ResponseMapper.fromDio(
      response,
    );
  }

  /// Converts DioException into NetworkException.
  Never throwMappedException(
    DioException error,
  ) {
    throw ExceptionMapper.fromDio(
      error,
    );
  }
}