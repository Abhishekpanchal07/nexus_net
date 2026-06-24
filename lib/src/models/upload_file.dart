/// Represents a file to upload.
class UploadFile {
  const UploadFile({
    required this.path,
    this.fieldName = 'file',
    this.fileName,
  });

  /// Local file path.
  final String path;

  /// Multipart field name.
  ///
  /// Example:
  /// image
  /// avatar
  /// document
  final String fieldName;

  /// Optional file name sent to server.
  final String? fileName;
}