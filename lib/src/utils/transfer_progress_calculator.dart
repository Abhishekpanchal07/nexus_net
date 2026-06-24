import '../models/transfer_progress_metrics.dart';

/// Utility for calculating transfer speed
/// and estimated remaining time.
class TransferProgressCalculator {
  const TransferProgressCalculator._();

  /// Calculates transfer metrics.
  static TransferProgressMetrics calculate({
    required int transferredBytes,
    required int totalBytes,
    required DateTime startedAt,
  }) {
    final elapsedSeconds =
        DateTime.now()
                .difference(startedAt)
                .inMilliseconds /
            1000;

    final speedInBytesPerSecond =
        elapsedSeconds > 0
            ? transferredBytes /
                elapsedSeconds
            : 0;

    Duration? remainingTime;

    if (speedInBytesPerSecond > 0 &&
        totalBytes > transferredBytes) {
      final remainingSeconds =
          (totalBytes - transferredBytes) /
              speedInBytesPerSecond;

      remainingTime = Duration(
        seconds: remainingSeconds.round(),
      );
    }

    return TransferProgressMetrics(
      speedInBytesPerSecond:
          speedInBytesPerSecond.toDouble(),
      remainingTime: remainingTime,
    );
  }
}