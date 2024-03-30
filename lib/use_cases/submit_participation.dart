import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:student_application/domain/error_response.dart';
import '../domain/student_participation.dart';
import '/shared/constants/api_constants.dart';

/// Submits the form to the server and returns the StudentParticipation
/// containing the streaming URL if the form was submitted successfully.
Future<StudentParticipation> submitForm(StudentParticipationForm formData) async {
  const url = backendApiUrl + studentParticipationEndpoint;
  final response = await http.post(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: jsonEncode(formData.toJson()),
  );

  if (response.statusCode == 200) {
    return StudentParticipation.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    var errorResponse = ErrorResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    throw Exception('Failed to submit form: ${errorResponse.message}');
  }
}
