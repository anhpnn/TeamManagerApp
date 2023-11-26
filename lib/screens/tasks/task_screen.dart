import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_manager_app/screens/tasks/taskInfoLeader_screen.dart';
import 'package:team_manager_app/screens/tasks/taskInfoMember_screen.dart';
import 'package:team_manager_app/services/auth_service.dart';
import 'package:team_manager_app/services/group_service.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final GroupService groupService = GroupService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String currentUserName = '';
  bool isCurrentUserLeader(String currentUserName, String leaderName) {
    return currentUserName == leaderName;
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  //* Get current user name
  Future<void> getUserInfo() async {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              CupertinoIcons.person_alt_circle,
              size: 40,
            ),
            const SizedBox(width: 15),
            Text(
              currentUserName.isNotEmpty ? currentUserName : "",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: groupService.getCreatedGroups(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Đã xảy ra lỗi: ${snapshot.error}');
          } else {
            final createdGroups = snapshot.data;
            if (createdGroups != null && createdGroups.isNotEmpty) {
              return ListView.builder(
                itemCount: createdGroups.length,
                itemBuilder: (context, index) {
                  final group = createdGroups[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: const Icon(CupertinoIcons.group_solid),
                        title: Text(
                          group['groupName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "Leader of group: ${group['leaderName']}\n"
                          'Number of member: ${group['members'].length}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          if (isCurrentUserLeader(
                              currentUserName, group['leaderName'])) {
                            Get.to(TaskInfoForLeader(
                              groupId: group['groupId'],
                            ));
                          } else {
                            Get.to(TaskInfoForMember(
                              groupId: group['groupId'],
                            ));
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("You don't have any group");
            }
          }
        },
      ),
    );
  }
}
