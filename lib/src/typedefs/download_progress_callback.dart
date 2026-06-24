import '../models/download_progress.dart';

/// Called whenever download progress changes.
typedef DownloadProgressCallback =
    void Function(
  DownloadProgress progress,
);