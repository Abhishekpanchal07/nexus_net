class ApiResponse {
  const ApiResponse({
    required this.data,
    required this.statusCode,
    this.headers = const {},
  });

  final dynamic data;

  final int statusCode;

  final Map<String, List<String>> headers;

  bool get isSuccess =>
      statusCode >= 200 &&
      statusCode < 300;
}