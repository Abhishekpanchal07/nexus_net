import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nexus_net/src/models/upload_progress.dart';

import '../client/nexus_client.dart';
import '../models/api_response.dart';
import '../models/network_request_options.dart';
import '../models/upload_file.dart';
import '../typedefs/upload_progress_callback.dart';
import '../utils/network_constants.dart';
import 'base_service.dart';
import '../utils/transfer_progress_calculator.dart';

class UploadService extends BaseService {
  const UploadService();

  /// Uploads one or more files using multipart/form-data.
  Future<ApiResponse> upload({
    required String endpoint,
    required List<UploadFile> files,
    Map<String, dynamic>? fields,
    NetworkRequestOptions? options,
    UploadProgressCallback? onProgress,
  }) async {
    final requestOptions = options ?? const NetworkRequestOptions();

    final cancelToken = createCancelToken(requestOptions);

    try {
      await checkConnectivity();

      final formData = FormData();

      // Add fields.
      if (fields != null) {
        formData.fields.addAll(
          fields.entries.map(
            (entry) => MapEntry(entry.key, entry.value.toString()),
          ),
        );
      }

      // Add files.
      for (final file in files) {
        formData.files.add(
          MapEntry(
            file.fieldName,
            await MultipartFile.fromFile(
              file.path,
              filename: file.fileName ?? File(file.path).uri.pathSegments.last,
            ),
          ),
        );
      }
      final startedAt = DateTime.now();
      final response = await NexusClient.dio.post(
        endpoint,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          if (onProgress == null) {
            return;
          }

          final metrics = TransferProgressCalculator.calculate(
            transferredBytes: sent,
            totalBytes: total,
            startedAt: startedAt,
          );

          onProgress(
            UploadProgress(
              transferredBytes: sent,
              totalBytes: total,
              speedInBytesPerSecond: metrics.speedInBytesPerSecond,
              remainingTime: metrics.remainingTime,
            ),
          );
        },
        options: Options(
          headers: requestOptions.additionalHeaders,
          extra: {
            NetworkConstants.authRequired: requestOptions.requiresAuth,

            // Upload requests should not
            // be automatically retried.
            NetworkConstants.retryOnFailure: false,
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
      disposeCancelToken(cancelToken, requestOptions);
    }
  }
}
