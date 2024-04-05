
class Participation {
  final int id;
  final String examId;
  final String classRoomId;
  final String studentId;
  final String fullName;
  final String email;
  final DateTime startTime;
  final String rtmpStreamUrl;

  Participation({
    required this.id,
    required this.examId,
    required this.classRoomId,
    required this.studentId,
    required this.fullName,
    required this.email,
    required this.startTime,
    required this.rtmpStreamUrl,
  });

  factory Participation.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'examId': String examId,
        'classRoomId': String classRoomId,
        'studentId': String studentId,
        'fullName': String fullName,
        'email': String email,
        'startTime': String startTime,
        'rtmpStreamUrl': String rtmpStreamUrl,
      } =>
        Participation(
          id: id,
          examId: examId,
          classRoomId: classRoomId,
          studentId: studentId,
          fullName: fullName,
          email: email,
          startTime: DateTime.parse(startTime),
          rtmpStreamUrl: rtmpStreamUrl,
        ),
      _ => throw Exception('Invalid JSON'),
    };
  }
}
