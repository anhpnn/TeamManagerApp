import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_manager_app/screens/groups/groupInfo_screen.dart';
import 'package:team_manager_app/services/group_service.dart';

// ignore: must_be_immutable
class AddMemberScreen extends StatefulWidget {
  String groupId;
  // ignore: use_key_in_widget_constructors
  AddMemberScreen({required this.groupId});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController emailController = TextEditingController();

  void addMemberMethod() {
    String email = emailController.text;
    GroupService().addMember(email, widget.groupId);
    Get.to(() => GroupInfoScreen(groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Member"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Enter Member's Email",
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: addMemberMethod,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Add Member"),
            ),
          ],
        ),
      ),
    );
  }
}
