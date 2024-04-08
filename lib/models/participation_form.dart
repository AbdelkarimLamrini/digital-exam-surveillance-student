class ParticipationForm {
  final String studentId;
  final String examId;
  final String classRoomId;
  final String fullName;
  final String email;

  ParticipationForm({
    required this.studentId,
    required this.examId,
    required this.classRoomId,
    required this.fullName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'examId': examId,
      'classRoomId': classRoomId,
      'fullName': fullName,
      'email': email,
    };
  }
}
