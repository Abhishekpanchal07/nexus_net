import 'package:dio/dio.dart';

import '../models/api_response.dart';

/// Utility responsible for converting
/// Dio responses into [ApiResponse].
class ResponseMapper {
  const ResponseMapper._();

  /// Converts a Dio [Response] into [ApiResponse].
  static ApiResponse fromDio(
    Response response,
  ) {
    return ApiResponse(
      data: response.data,
      statusCode: response.statusCode ?? 200,
      headers: Map<String, List<String>>.from(
        response.headers.map,
      ),
    );
  }
}