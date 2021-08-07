import 'package:cloud_firestore/cloud_firestore.dart';

class DriverData {
  final double lon;
  final double lat;
  final String name;

  DriverData({this.lon = 0, this.lat = 0, this.name = ""});

  DriverData.fromSnapShot(DocumentSnapshot snapshot)
      : lon = snapshot['Lon'],
        lat = snapshot['Lat'],
        name = snapshot['Name'];
}
