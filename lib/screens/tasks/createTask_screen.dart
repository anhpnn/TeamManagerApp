import 'package:flutter/material.dart';
import 'package:team_manager_app/services/task_service.dart';
import 'package:date_time_picker/date_time_picker.dart';


class CreateTaskScreen extends StatefulWidget {
  final String groupId;
  const CreateTaskScreen({required this.groupId});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TaskService taskService = TaskService();

  String _taskName = '';
  String _description = '';
  DateTime _deadline = DateTime.now();
  String? _selectedMember;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _taskName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMMM, yyyy - HH:mm a',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                icon: const Icon(Icons.event),
                dateLabelText: 'Deadline',
                onChanged: (val) {
                  setState(() {
                    _deadline = DateTime.parse(val);
                  });
                },
              ),
              FutureBuilder<List<String>>(
                future: taskService.fetchMembersFromFirestore(widget.groupId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final members = snapshot.data;
                    return DropdownButtonFormField<String>(
                      value: _selectedMember,
                      items: members?.map((member) {
                        return DropdownMenuItem<String>(
                          value: member,
                          child: Text(member),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMember = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Assigned Member'),
                    );
                  }
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedMember != null) {
        // Sử dụng TaskService để tạo nhiệm vụ
        taskService.createTask(
          groupId: widget.groupId,
          taskName: _taskName,
          description: _description,
          deadline: _deadline,
          assignedMember: _selectedMember!,
        );

        // Thực hiện các tác vụ khác sau khi tạo nhiệm vụ

        Navigator.pop(context);
      }
    }
  }
}
