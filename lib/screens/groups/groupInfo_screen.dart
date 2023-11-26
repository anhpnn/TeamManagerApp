import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_manager_app/screens/chat/chat_screen.dart';
import 'package:team_manager_app/screens/groups/addMember_screen.dart';
import 'package:team_manager_app/services/group_service.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  // ignore: use_key_in_widget_constructors
  const GroupInfoScreen({required this.groupId});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final GroupService groupService = GroupService();
  List<String> groupMembers = [];
  bool showFloatingButton = false;
  String currentUserName = '';

  @override
  void initState() {
    super.initState();
    groupService.getGroupMembers(widget.groupId).then((members) {
      setState(() {
        groupMembers = members;
      });
    });
    groupService.getCurrentUserNameFromUsersCollection(FirebaseAuth.instance.currentUser!.uid).then((userName) {
      if (userName != null) {
        currentUserName = userName;
        // Tiếp theo, bạn có thể thực hiện kiểm tra leaderName và cập nhật showFloatingButton
        groupService.getLeaderName(widget.groupId).then((leaderName) {
          if (leaderName == currentUserName) {
            setState(() {
              showFloatingButton = true;
            });
          }
        });
      }
    });
  }

  void navigateToAddMemberScreen() {
    Get.to(() => AddMemberScreen(groupId: widget.groupId));
  }

  void navigateToChatScreen() {
    Get.to(() => ChatScreen(groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Detail"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            onPressed: navigateToChatScreen,
            icon: const Icon(CupertinoIcons.chat_bubble_text_fill, size: 30),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: ListView.builder(
        itemCount: groupMembers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading:
                    const Icon(CupertinoIcons.person_alt_circle_fill, size: 35),
                title: Text(groupMembers[index]),
                trailing: IconButton(
                  onPressed: () {
                    groupService.removeMemberFromGroup(
                        widget.groupId);
                  },
                  icon: const Icon(CupertinoIcons.delete_solid, size: 30),
                )
              ),
            ),
          );
        },
      ),
      floatingActionButton: showFloatingButton
          ? FloatingActionButton(
              onPressed: navigateToAddMemberScreen,
              backgroundColor: Colors.blueGrey[700],
              child: const Icon(
                CupertinoIcons.person_add_solid,
                size: 32,
              ),
            )
          : null,
    );
  }
}
