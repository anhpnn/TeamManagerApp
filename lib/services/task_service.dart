import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_manager_app/models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTask({
    required String groupId,
    required String taskName,
    required String description,
    required DateTime deadline,
    required String assignedMember,
  }) async {
    try {
      // Tạo nhiệm vụ và lưu vào Firestore
      final taskRef = _firestore.collection('groups/$groupId/tasks').doc();
      await taskRef.set({
        'taskName': taskName,
        'description': description,
        'deadline': deadline,
        'assignedMember': assignedMember,
        'status': 'Pending',
      });
      // Sau khi tạo nhiệm vụ, bạn có thể thực hiện các tác vụ khác, ví dụ gửi thông báo.
    } catch (error) {
      print('Error creating task: $error');
      throw error;
    }
  }

  Future<List<String>> fetchMembersFromFirestore(String groupId) async {
    final DocumentSnapshot groupDoc =
        await _firestore.collection('groups').doc(groupId).get();
    final Map<String, dynamic>? data = groupDoc.data() as Map<String, dynamic>?;

    final List<dynamic> members = data?['members'] ?? [];

    return members.cast<String>().toList();
  }

  Stream<List<TaskModel>> getTasksStream(String groupId) {
    return _firestore
        .collection('groups/$groupId/tasks')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TaskModel(
          taskName: data['taskName'],
          description: data['description'],
          deadline: data['deadline'].toDate(),
          assignedMember: data['assignedMember'],
          status: data['status'], // Lấy thông tin trạng thái
        );
      }).toList();
    });
  }

  Future<void> updateStatusForGroup(
      String groupId, String updatedStatus) async {
    try {
      final taskRefs =
          await _firestore.collection('groups/$groupId/tasks').get();

      for (final taskRef in taskRefs.docs) {
        await taskRef.reference.update({
          'status': updatedStatus,
        });
      }
    } catch (error) {
      print('Error updating task status: $error');
      throw error;
    }
  }

  void deleteTask(String groupId, String taskName) {
    _firestore
        .collection('groups/$groupId/tasks')
        .where('taskName', isEqualTo: taskName)
        .get()
        .then((snapshot) {
      for (final DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
