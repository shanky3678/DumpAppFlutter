import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dump/Model/UserData.dart';
import 'package:dump/locator.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/widget/LoadingState.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ResidentalNotification extends StatefulWidget {
  ResidentalNotification({Key key}) : super(key: key);

  @override
  _ResidentalNotificationState createState() => _ResidentalNotificationState();
}

class _ResidentalNotificationState extends State<ResidentalNotification> {
  final AuthService _authService = locator<AuthService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  UserData get currentUser => _authService.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: _buildSteamBuilder(),
    );
  }

  defaultview() {
    return Center(
      child: Text("No connection."),
    );
  }

  _buildSteamBuilder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ResidentCredentials")
            .doc(currentUser.userId)
            .collection("Notifications")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingState();
          } else if (snapshot.connectionState == ConnectionState.none) {
            return defaultview();
          } else
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Text("Message " +
                            documentSnapshot['message'] +
                            "\n" +
                            timeago.format(documentSnapshot['timestamp'])),
                      ))
                ]);
              },
            );
        });
  }
}
