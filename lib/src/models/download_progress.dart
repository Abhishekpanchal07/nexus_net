import 'transfer_progress.dart';

/// Represents download progress information.
class DownloadProgress extends TransferProgress {
  const DownloadProgress({
    required super.transferredBytes,
    required super.totalBytes,
    required super.speedInBytesPerSecond,
    super.remainingTime,
  });

  int get receivedBytes => transferredBytes;
}