import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String groupId, String senderUserName, String message) async {
    try {
      await _firestore
          .collection('group_chats')
          .doc(groupId)
          .collection('messages')
          .add({
        'senderUserName':
            senderUserName, // Use senderUserName instead of senderId
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Lỗi khi gửi tin nhắn: $e');
    }
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
        .collection('group_chats')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }
}
