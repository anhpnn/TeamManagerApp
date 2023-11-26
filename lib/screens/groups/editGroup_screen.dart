import 'package:flutter/material.dart';

class EditGroupScreen extends StatefulWidget {


  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Group"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(
        child: const Center(
          child: Text("Edit Group"),
        ),
      ),
    );
  }
}
