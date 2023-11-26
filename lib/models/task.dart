class TaskModel {
  final String taskName;
  final String description;
  final DateTime deadline;
  final String assignedMember;
  String status; // Thêm trường trạng thái

  TaskModel({
    required this.taskName,
    required this.description,
    required this.deadline,
    required this.assignedMember,
    required this.status, // Thêm trường trạng thái
  });
}
