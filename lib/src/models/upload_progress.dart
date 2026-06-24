import 'transfer_progress.dart';

/// Represents upload progress information.
class UploadProgress extends TransferProgress {
  const UploadProgress({
    required super.transferredBytes,
    required super.totalBytes,
    required super.speedInBytesPerSecond,
    super.remainingTime,
  });

  int get sentBytes => transferredBytes;
}