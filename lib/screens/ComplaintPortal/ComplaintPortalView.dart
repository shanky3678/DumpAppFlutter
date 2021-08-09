import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/services/navigationService.dart';
import 'package:dump/widget/LoadingState.dart';
import 'package:flutter/material.dart';

class ComplaintLanding extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await _navigationService.navigateTo(ComplaintRoute);
          },
        ),
        appBar: AppBar(
          title: Text('Complaint Portal'),
        ),
        //Body containing the image, three texts and a button
        body: _buildSteamBuilder());
  }

  _buildSteamBuilder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("AllComplaints")
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
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: documentSnapshot['Complaint'] + "\n\n",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24)),
                            TextSpan(
                                text: documentSnapshot['subject'] + "\n",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          ]),
                        ),
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
          alignment: Alignment(0, -0.8),
          child: Image(
            image: AssetImage('assets/images/question_mark.png'),
            height: 150,
            width: 150,
          ),
        ),
        //Text line one
        Align(
          alignment: Alignment(0, -0.2),
          child: Text("You don't have any previous",
              style: TextStyle(color: Colors.grey)),
        ),
        //Text line two
        Align(
          alignment: Alignment(0, -0.1),
          child: Text("complaint registered",
              style: TextStyle(color: Colors.grey)),
        ),
        //Text line three
        Align(
          alignment: Alignment(0, 0),
          child: Text("Have an issue?", style: TextStyle(color: Colors.grey)),
        ),

        SizedBox(
          height: 20,
        ),
        //Button
        Align(
            alignment: Alignment(0, 0.1),
            child: RaisedButton(
              onPressed: () async {
                await _navigationService.navigateTo(ComplaintRoute);
              },
              child: Text("Raise a complaint"),
              color: Color.fromRGBO(242, 161, 84, 1),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0)),
            ))
      ],
    );
  }
}

class ComplaintForm extends StatefulWidget {
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _complaint = TextEditingController();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  void validate(BuildContext context) async {
    if (formkey.currentState.validate()) {
      var result =
          await _firebaseService.addComplain(_subject.text, _complaint.text);
      print("Ok");
      if (result) {
        _complaint.clear();
        _subject.clear();
        final snackBar = SnackBar(content: Text("Submitted Successfully."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      print("Error");
      final snackBar = SnackBar(content: Text("Something went wrong."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit A Complaint"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Center(
            child: Form(
              autovalidate: true,
              key: formkey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _subject,
                      decoration: InputDecoration(
                          labelText: "Subject",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0))),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _complaint,
                      maxLines: 5,
                      decoration: InputDecoration(
                          labelText: "Complaint",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0))),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        onPressed: () => validate(context),
                        child: Text("SUBMIT"),
                        color: Color.fromRGBO(242, 161, 84, 1),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0)),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
