import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_manager_app/models/task.dart';
import 'package:team_manager_app/services/auth_service.dart';
import 'package:team_manager_app/services/task_service.dart';

class TaskInfoForMember extends StatefulWidget {
  final String groupId;

  const TaskInfoForMember({required this.groupId});

  @override
  State<TaskInfoForMember> createState() => _TaskInfoForMemberState();
}

class _TaskInfoForMemberState extends State<TaskInfoForMember> {
  final TaskService _taskService = TaskService();
  String currentUserName = '';
  bool isCompletedButton = false;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userService = AuthService();
      final userName = await userService.getUserNameByUserId(userId);
      if (userName != null) {
        setState(() {
          currentUserName = userName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Detail (Member)"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: _taskService.getTasksStream(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final tasks = snapshot.data ?? [];

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final dateFormat = DateFormat("HH:mm - dd/MM/yy");
              final formattedDeadline = dateFormat.format(task.deadline);

              // Check whether the task is assigned to the current user or not
              final isCurrentUserAssigned =
                  task.assignedMember == currentUserName;

              if (isCurrentUserAssigned) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      leading: const Icon(Icons.task_sharp, size: 50),
                      title: Text(
                        "Name task: ${task.taskName}",
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black87),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description: ${task.description}",
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black87),
                          ),
                          Text(
                            "Deadline: $formattedDeadline",
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 17,
                                color: Colors.black87),
                          ),
                          Text(
                            "Assigned member: ${task.assignedMember}",
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black87),
                          ),
                          isCompletedButton
                              ? Text(
                                  "Status: ${task.status}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.black87),
                                )
                              : const SizedBox.shrink(),
                          isCompletedButton
                              ? const SizedBox.shrink()
                              : ElevatedButton(
                                  onPressed: () {
                                    // Thay đổi trạng thái của task thành Complete
                                    _taskService.updateStatusForGroup(
                                        widget.groupId, 'Completed');
                                    setState(() {
                                      isCompletedButton = true;
                                    });
                                  },
                                  child: const Text('Pending'),
                                )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink(); // return an empty widget
              }
            },
          );
        },
      ),
    );
  }
}
