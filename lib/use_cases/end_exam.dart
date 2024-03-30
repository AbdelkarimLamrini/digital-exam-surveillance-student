import 'package:http/http.dart' as http;
import 'package:student_application/domain/student_participation.dart';
import '/shared/constants/api_constants.dart';

/// Submits the form to the server and returns the streaming URL if the form was submitted successfully.
Future<String> endExam(StudentParticipation participation) async {
  var url = '$backendApiUrl$studentParticipationEndpoint/${participation.id}';
  final response = await http.delete(
    Uri.parse(url),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to end exam: ${response.body}');
  }
}