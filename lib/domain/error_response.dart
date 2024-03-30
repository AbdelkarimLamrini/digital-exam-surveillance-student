class ErrorResponse {
  final int status;
  final String error;
  final String message;

  ErrorResponse({
    required this.status,
    required this.error,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'status': int status,
        'error': String error,
        'message': String message,
      } =>
        ErrorResponse(
          status: status,
          error: error,
          message: message,
        ),
      _ => throw Exception('Invalid ErrorResponse JSON'),
    };
  }
}
