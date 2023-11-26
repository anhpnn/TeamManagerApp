import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_manager_app/models/user.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  //* Sign Up /
  Future signUp(String userName, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel newUser = UserModel(
          userId: userCredential.user!.uid,
          userName: userName,
          email: email,
          password: password,
          groups: []);
      dynamic resultUser = await AuthService().addNewUser(newUser);
      if (resultUser != null) {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] =
            "You cannot signup at this time. Try again later";
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      print("Failed to add user: $e");
      return null;
    }
  }

  //* Add new user
  Future addNewUser(UserModel user) async {
    return await firestore.collection("users").doc(user.userId).set({
      "userId": user.userId,
      "userName": user.userName,
      "email": user.email,
      "groups": user.groups,
    }).then((value) async {
      await UserModel.setUserNameSF(user.userName);
      return user;
    }).catchError((error) {
      print("Failed to add user $error");
      return error;
    });
  }

  //* Sign In /
  Future signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel newUser = UserModel(
        userId: userCredential.user!.uid,
        userName: '',
        email: email,
        password: password,
        groups: [],
      );
      dynamic resultUser = await AuthService().getUserDetails(newUser);
      if (resultUser != null) {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] =
            "Your email or password is incorrect. Try again later";
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      print("Failed to sign in: $e");
      return null;
    }
  }

  //* Get user details
  Future getUserDetails(UserModel user) async {
    return await firestore
        .collection("users")
        .doc(user.userId)
        .get()
        .then((value) async {
      UserModel userModel = UserModel();
      userModel.userId = user.userId;
      userModel.password = user.password;
      return userModel;
    }).catchError((error) {
      print('Failed to add user $error');
      return error;
    });
  }

  //* Get user name by user id
  Future<String?> getUserNameByUserId(String userId) async {
    final userQuery = await firestore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userData = userQuery.docs.first.data();
      final userName = userData['userName'];
      return userName;
    } else {
      return null; // user not found and have error
    }
  }
}
