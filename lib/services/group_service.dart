import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future createGroup(String groupName, String userId) async {
    final DocumentReference groupRef =
        firestore.collection('groups').doc(); // Create groupRef

    final userSnapshot = await firestore.collection('users').doc(userId).get();
    final leaderName = userSnapshot['userName'];

    final groupData = {
      'groupId': groupRef.id, // Auto generate id
      'groupName': groupName,
      'members': [leaderName], // Add leader to members
      'leaderName': leaderName,
    };

    await groupRef.set(groupData);

    // Update group collection 'users'
    await firestore.collection('users').doc(userId).update({
      'groups': FieldValue.arrayUnion([groupName]),
    });

    String groupId = groupRef.id;
    return groupId;
  }

  //* Get created groups
  Future<List<Map<String, dynamic>>> getCreatedGroups(String userId) async {
    final userSnapshot = await firestore.collection('users').doc(userId).get();
    final userGroups = userSnapshot.data()?['groups'];

    final List<Map<String, dynamic>> createdGroups = [];

    if (userGroups != null && userGroups is List) {
      for (String groupName in userGroups) {
        final querySnapshot = await firestore
            .collection('groups')
            .where('groupName', isEqualTo: groupName)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final groupData = querySnapshot.docs.first.data();
          createdGroups.add(groupData);
        }
      }
    }
    return createdGroups;
  }

  //* Add member to group
  Future<void> addMember(String email, String groupId) async {
    // Check email have existed in collection 'users'
    final userQuery = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userDoc = userQuery.docs.first;
      final userId = userDoc.id;
      final userName = userDoc['userName'];

      // Cập nhật member vào collection 'groups'
      final groupData = {
        'members': FieldValue.arrayUnion([userName]),
      };

      await firestore.collection('groups').doc(groupId).update(groupData);

      // Update group collection 'users'
      await firestore
          .collection('groups')
          .doc(groupId)
          .get()
          .then((value) async {
        final groupName = value['groupName'];
        final userGroupData = {
          'groups': FieldValue.arrayUnion([groupName]),
        };

        await firestore.collection('users').doc(userId).update(userGroupData);
      });
    } else {
      // Xử lý trường hợp email không tồn tại trong collection 'users'.
    }
  }

  //* Get all members in group
  Future<List<String>> getGroupMembers(String groupId) async {
    final groupSnapshot =
        await firestore.collection('groups').doc(groupId).get();
    final members = groupSnapshot.data()?['members'];

    if (members != null && members is List) {
      return members.cast<String>();
    }

    return [];
  }

  Future<String?> getLeaderName(String groupId) async {
    try {
      final DocumentSnapshot groupDoc =
          await firestore.collection('groups').doc(groupId).get();
      if (groupDoc.exists) {
        final data = groupDoc.data() as Map<String, dynamic>;
        final leaderName = data['leaderName'] as String?;
        return leaderName;
      }
      return null; // Trả về null nếu không tìm thấy thông tin nhóm hoặc không có leaderName
    } catch (e) {
      print('Lỗi khi lấy tên người dẫn đầu: $e');
      return null;
    }
  }

  //* Get current user name from collection 'users'
  Future<String?> getCurrentUserNameFromUsersCollection(String userId) async {
    try {
      final QuerySnapshot usersCollection = await firestore
          .collection('users')
          .where('userId', isEqualTo: userId)
          .get();

      if (usersCollection.docs.isNotEmpty) {
        final userData =
            usersCollection.docs.first.data() as Map<String, dynamic>;
        final userName = userData['userName'] as String?;
        return userName;
      }
      return null; 
    } catch (e) {
      print('Lỗi khi lấy tên người dùng: $e');
      return null;
    }
  }

  void removeMemberFromGroup(String groupId) {

  }
}
