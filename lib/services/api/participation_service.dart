import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:student_application/models/participation.dart';

import '/models/error_response.dart';
import '/models/participation_form.dart';
import '/shared/constants/api_constants.dart';

Future<Participation> startParticipation(ParticipationForm formData) async {
  const url = backendApiUrl + studentParticipationEndpoint;
  final response = await http.post(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: jsonEncode(formData.toJson()),
  );

  if (response.statusCode == 200) {
    return Participation.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  } else {
    throw ErrorResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}

Future<String> endParticipation(Participation participation) async {
  var url = '$backendApiUrl$studentParticipationEndpoint/${participation.id}';
  final response = await http.delete(
    Uri.parse(url),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw ErrorResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
