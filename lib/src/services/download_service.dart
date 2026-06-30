import 'package:dio/dio.dart';
import '../client/nexus_client.dart';
import '../models/download_progress.dart';
import '../models/network_request_options.dart';
import '../typedefs/download_progress_callback.dart';
import '../utils/network_constants.dart';
import '../utils/transfer_progress_calculator.dart';
import 'base_service.dart';

class DownloadService extends BaseService {
  const DownloadService();

  /// Downloads a file from [url] and saves it to [savePath]
  Future<void> download({
    required String url,
    required String savePath,
    NetworkRequestOptions? options,
    DownloadProgressCallback? onProgress,
  }) async {
    final requestOptions = options ?? const NetworkRequestOptions();

    final cancelToken = createCancelToken(requestOptions);

    final startedAt = DateTime.now();

    try {
      await checkConnectivity();

      await NexusClient.dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (onProgress == null) {
            return;
          }

          final metrics = TransferProgressCalculator.calculate(
            transferredBytes: received,
            totalBytes: total,
            startedAt: startedAt,
          );

          onProgress(
            DownloadProgress(
              transferredBytes: received,
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

            // Downloads should not retry
            // automatically.
            NetworkConstants.retryOnFailure: false,
          },
          sendTimeout: requestOptions.sendTimeout,
          receiveTimeout: requestOptions.receiveTimeout,
        ),
      );
    } on DioException catch (error, stackTrace) {
      NexusClient.config.onError?.call(error, stackTrace);

      throwMappedException(error);
    } finally {
      disposeCancelToken(cancelToken, requestOptions);
    }
  }
}
