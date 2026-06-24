/// Base model representing file transfer progress.
///
/// Shared by upload and download operations.
abstract class TransferProgress {
  const TransferProgress({
    required this.transferredBytes,
    required this.totalBytes,
    required this.speedInBytesPerSecond,
    this.remainingTime,
  });

  /// Bytes transferred so far.
  final int transferredBytes;

  /// Total bytes to transfer.
  final int totalBytes;

  /// Transfer speed in bytes per second.
  final double speedInBytesPerSecond;

  /// Estimated time remaining.
  final Duration? remainingTime;

  /// Progress between 0 and 1.
  double get progress {
    if (totalBytes <= 0) {
      return 0;
    }

    return transferredBytes / totalBytes;
  }

  /// Progress percentage between 0 and 100.
  double get percentage {
    return progress * 100;
  }

  /// Remaining bytes.
  int get remainingBytes {
    return (totalBytes - transferredBytes)
        .clamp(0, totalBytes);
  }

  /// Speed in KB/s.
  double get speedInKBps {
    return speedInBytesPerSecond / 1024;
  }

  /// Speed in MB/s.
  double get speedInMBps {
    return speedInBytesPerSecond /
        (1024 * 1024);
  }

  /// Transferred size in MB.
  double get transferredMB {
    return transferredBytes /
        (1024 * 1024);
  }

  /// Total size in MB.
  double get totalMB {
    return totalBytes /
        (1024 * 1024);
  }

  /// Whether transfer has completed.
  bool get isCompleted {
    return transferredBytes >= totalBytes;
  }
}