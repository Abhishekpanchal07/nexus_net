import '../models/upload_progress.dart';

/// Called whenever upload progress changes.
typedef UploadProgressCallback = void Function(
  UploadProgress progress,
);