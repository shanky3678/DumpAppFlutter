import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dump/Model/UserData.dart';
import 'package:dump/Model/driverData.dart';
import 'package:dump/screens/Constant/const.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService {
  final CollectionReference _residentCollection =
      FirebaseFirestore.instance.collection("ResidentCredentials");
  final CollectionReference _driverCollection =
      FirebaseFirestore.instance.collection("DriverCredentials");
  final CollectionReference _allComplaints =
      FirebaseFirestore.instance.collection("AllComplaints");
  final CollectionReference _allRequests =
      FirebaseFirestore.instance.collection("AllRequests");

  final StreamController<DriverData> _streamController =
      StreamController<DriverData>();
  FirebaseService() {
    print("running streaming");
    _driverCollection.snapshots().listen(_driverLatLon);
  }
  //listeners
  int listener = 0;

  Future getUser(String uid) async {
    //TODO: not completed
    try {
      var userData = await _residentCollection.doc(uid).get();
      if (userData.data() != null) {
        return UserData.fromData(userData.data());
      } else {
        var driverData = await _driverCollection.doc(uid).get();
        if (driverData.data() != null) {
          return UserData.fromData(driverData.data());
        } else
          return null;
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<bool> updateData(
  //     {@required String userId,
  //     String name,
  //     double lon,
  //     double lat,
  //     String address,
  //     String phoneNumber,
  //     @required String type}) async {
  //   var status;
  //   if (type == Resident) {
  //     _residentCollection
  //         .doc(userId)
  //         .update({
  //           "AndroidToken": "",
  //           "Name": name,
  //           "Address": address,
  //           "PhoneNumber": phoneNumber,
  //           "Type": type,
  //           "UserId": userId,
  //           "Lon": lon,
  //           "Lat": lat,
  //         })
  //         .then((value) => status = true)
  //         .catchError(() => status = false);
  //   } else {
  //     _driverCollection
  //         .doc(userId)
  //         .update({
  //           "Name": name,
  //           "PhoneNumber": phoneNumber,
  //           "Type": type,
  //           "UserId": userId,
  //           "Address": address,
  //           "Lon": lon,
  //           "Lat": lat,
  //         })
  //         .then((value) => status = true)
  //         .catchError(() => status = false);
  //   }
  //   return status;
  // }

  Future<bool> liveLocationUpdate(
      {@required String userId,
      double lon,
      double lat,
      @required String type}) async {
    var status;
    if (type == Resident) {
      _residentCollection.doc(userId).update({
        "Type": type,
        "UserId": userId,
        "Lon": lon,
        "Lat": lat,
      }).then((value) async {
        status = true;
      }).catchError(() => status = false);
    } else {
      _driverCollection
          .doc(userId)
          .update({
            "Type": type,
            "UserId": userId,
            "Lon": lon,
            "Lat": lat,
          })
          .then((value) => status = true)
          .catchError(() => status = false);
    }
    return status;
  }

  // addComplaint({String? userId, String? subject, String? complaint}) async {
  //   await _allComplaints
  //       .add({"userId": userId, "subject": subject, "complaint": complaint});
  // }

  // addRequest({String? userId, String? subject, String? complaint}) async {
  //   await _allComplaints
  //       .add({"userId": userId, "subject": subject, "complaint": complaint});
  // }

  Future<bool> checkDetails(String phoneNumber, String type) async {
    if (type == Driver) {
      try {
        var result = await _driverCollection
            .where(
              "PhoneNumber",
              isEqualTo: phoneNumber,
            )
            .limit(1)
            .get();
        print(result);
        if (result.docs.length > 0) {
          return true;
        } else
          return false;
      } catch (e) {
        print(e);
        return false;
      }
    } else if (type == Resident) {
      try {
        var result = await _residentCollection
            .where(
              "PhoneNumber",
              isEqualTo: phoneNumber,
            )
            .limit(1)
            .get();
        print(result);
        if (result.docs.length > 0) {
          return true;
        } else
          return false;
      } catch (e) {
        print(e);
        return false;
      }
    } else
      return false;
  }

  Future<bool> addDetails(
      String name,
      String phoneNumber,
      String type,
      String userId,
      String address,
      double lat,
      double lon,
      String token) async {
    if (type == Driver) {
      try {
        await _driverCollection.doc(userId).set({
          "Name": name,
          "PhoneNumber": phoneNumber,
          "Type": type,
          "UserId": userId,
          "Address": address,
          "Lon": lon,
          "Lat": lat,
        });
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else if (type == Resident) {
      try {
        await _residentCollection.doc(userId).set({
          "AndroidToken": token,
          "Name": name,
          "PhoneNumber": phoneNumber,
          "Type": type,
          "UserId": userId,
          "Address": address,
          "Lon": lon,
          "Lat": lat,
        });

        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else
      return false;
  }

  Future<List<UserData>> getResidentDetails() async {
    List<UserData> allResidentDetails = [];
    var querySnapShot = await _residentCollection.get();
    for (int i = 0; i < querySnapShot.docs.length; i++) {
      var userData = UserData.fromData(querySnapShot.docs[i].data());
      allResidentDetails.add(userData);
    }
    return allResidentDetails;
  }

  Stream<DriverData> get driverLiveData => _streamController.stream;

  void _driverLatLon(QuerySnapshot snapshot) {
    for (var doc in snapshot.docs) {
      _streamController.add(DriverData.fromSnapShot(doc));
    }
  }

  getNotification(
    String userId,
  ) async {
    List notifications = [];
    QuerySnapshot notification =
        await _residentCollection.doc(userId).collection("Notifications").get();
    for (var doc in notification.docs) {
      notifications.add(doc['message']);
    }
    return notifications;
  }

  Future<bool> addComplain(String subject, String complaint) async {
    try {
      await _allComplaints.add({
        "subject": subject,
        "Complaint": complaint,
        "timestamp": Timestamp.now()
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateLocationResidentalUser(lat, lon, userId) async {
    try {
      await _residentCollection.doc(userId).update({"Lat": lat, "Lon": lon});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPickUpRequest(
    String date,
    String time,
    String address,
  ) async {
    try {
      await _allRequests.add({
        "date": date,
        "timeofpickup": time,
        "timeofrequest": Timestamp.now(),
        "address": address
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  updateToken(userId, String token) async {
    await _residentCollection.doc(userId).update({"AndroidToken": token});
  }
}
