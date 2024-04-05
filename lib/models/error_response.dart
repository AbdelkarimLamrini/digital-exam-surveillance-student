class ErrorResponse implements Exception {
  final int status;
  final String error;
  final String message;
  final Map<String, String> fieldErrors;

  ErrorResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.fieldErrors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'status': int status,
        'error': String error,
        'message': String message,
        'fieldErrors': Map<String, String> fieldErrors,
      } =>
        ErrorResponse(
          status: status,
          error: error,
          message: message,
          fieldErrors: fieldErrors,
        ),
      _ => throw Exception('Invalid ErrorResponse JSON'),
    };
  }
}