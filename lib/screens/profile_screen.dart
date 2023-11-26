import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_manager_app/screens/auth/signin_screen.dart';

// ignore: use_key_in_widget_constructors
class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[700],
          title: const Text('Setting Screen',
              style: TextStyle(color: Colors.white, fontSize: 22)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueGrey),
                    ),
                    child: const Text("Log Out",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Get.to(() => const SignInScreen());
                      });
                    },
                  ),
                ),
              ]),
        ));
  }
}
