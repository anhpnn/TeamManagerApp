import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_manager_app/services/auth_service.dart';
import 'package:team_manager_app/services/chat_service.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  String groupId;
  // ignore: use_key_in_widget_constructors
  ChatScreen({required this.groupId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService chatService = ChatService();
  final TextEditingController messageController = TextEditingController();
  String currentUserName = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Nếu cuộn đến cuối, tự động cuộn xuống khi có tin nhắn mới
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
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
      appBar: AppBar(
        title: const Text('Chat group'),
        backgroundColor: Colors.blueGrey[700],
        iconTheme: IconThemeData(
          color: Colors.white, // Đặt màu biểu tượng ứng dụng
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatService.getGroupMessages(widget.groupId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Failed to: ${snapshot.error}'));
                }
                final messages = snapshot.data?.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages!) {
                  final senderUserName = message['senderUserName'];
                  final messageText = message['message'];
                  messageWidgets.add(
                    ListTile(
                      title: Text(senderUserName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(messageText,
                          style: const TextStyle(color: Colors.blue)),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messageWidgets.length,
                  itemBuilder: (context, index) {
                    final senderUserName =
                        messages[messages.length - index - 1]['senderUserName'];
                    final messageText =
                        messages[messages.length - index - 1]['message'];
                    final isMyMessage = senderUserName == currentUserName;

                    return Row(
                      mainAxisAlignment: isMyMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isMyMessage)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              senderUserName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        Expanded(
                          child: Align(
                            alignment: isMyMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: SizedBox(
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: 5,
                                    left: isMyMessage ? 70 : 0,
                                    right: isMyMessage ? 0 : 65),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      isMyMessage ? Colors.green : Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMyMessage
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      messageText,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal,
                                          color: isMyMessage
                                              ? Colors.white
                                              : Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isMyMessage)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              senderUserName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                        ),
                      ),
                      labelText: 'Enter message ...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.green),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      chatService.sendMessage(
                        widget.groupId,
                        currentUserName,
                        messageController.text,
                      );
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
