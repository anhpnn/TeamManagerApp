import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_manager_app/models/task.dart';
import 'package:team_manager_app/screens/tasks/createTask_screen.dart';
import 'package:team_manager_app/services/task_service.dart';
import 'package:intl/intl.dart';

class TaskInfoForLeader extends StatefulWidget {
  final String groupId;

  const TaskInfoForLeader({required this.groupId});

  @override
  State<TaskInfoForLeader> createState() => _TaskInfoForLeaderState();
}

class _TaskInfoForLeaderState extends State<TaskInfoForLeader> {
  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Detail"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateTaskScreen(groupId: widget.groupId));
        },
        backgroundColor: Colors.blueGrey[700],
        child: const Icon(CupertinoIcons.add_circled_solid, size: 32),
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
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black87),
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
                        Text(
                          "Status: ${task.status}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _taskService.deleteTask(widget.groupId, task.taskName);
                      },
                      icon: Icon(CupertinoIcons.delete_solid,
                          color: Colors.redAccent, size: 40),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
