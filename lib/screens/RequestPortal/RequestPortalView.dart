import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';
import 'package:dump/services/navigationService.dart';
import 'package:dump/widget/LoadingState.dart';
import 'package:flutter/material.dart';

class RequestLanding extends StatefulWidget {
  @override
  _RequestLandingState createState() => _RequestLandingState();
}

class _RequestLandingState extends State<RequestLanding> {
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await _navigationService.navigateTo(RequestFormRoute);
          },
        ),
        appBar: AppBar(
          title: Text('Request Portal'),
        ),
        //Body containing the image, two texts and a button
        body: _buildSteamBuilder());
  }

  _buildSteamBuilder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("AllRequests")
            .orderBy("timeofrequest", descending: true)
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
                        child: Text("Pick Up Requests\n\nTime " +
                            documentSnapshot['timeofpickup'] +
                            "\nDate" +
                            documentSnapshot['date'] +
                            "\nAddress" +
                            documentSnapshot['address']),
                      ))
                ]);
              },
            );
        });
  }

  defaultview() {
    return Stack(
      children: <Widget>[
        //The image
        Align(
          alignment: Alignment(0, -0.2),
          child: Image(
            image: AssetImage('assets/images/dustbin.png'),
            height: 150,
            width: 150,
          ),
        ),
        //Text line one
        Align(
          alignment: Alignment(0, -0.2),
          child: Text("Do you have a large amount of",
              style: TextStyle(color: Colors.grey)),
        ),
        //Text line two
        Align(
          alignment: Alignment(0, -.1),
          child: Text("waste waiting to be disposed?",
              style: TextStyle(color: Colors.grey)),
        ),
        //Button
        Align(
            alignment: Alignment(0, 0.4),
            child: RaisedButton(
              onPressed: () async {
                await _navigationService.navigateTo(RequestFormRoute);
              },
              child: Text("Request a pickup"),
              color: Color.fromRGBO(242, 161, 84, 1),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0)),
            ))
      ],
    );
  }
}
