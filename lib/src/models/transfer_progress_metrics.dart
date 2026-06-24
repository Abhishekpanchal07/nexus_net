/// Internal model containing transfer metrics.
class TransferProgressMetrics {
  const TransferProgressMetrics({
    required this.speedInBytesPerSecond,
    required this.remainingTime,
  });

  /// Current transfer speed in bytes per second.
  final double speedInBytesPerSecond;

  /// Estimated remaining time.
  final Duration? remainingTime;
}