class UserData {
  final String userId;
  final String phoneNumber;
  final double lon;
  final double lat;
  final String address;
  final String name;
  final String type;

  UserData(
      {this.userId,
      this.phoneNumber,
      this.lon,
      this.lat,
      this.address,
      this.type,
      this.name});

  UserData.fromData(Map<String, dynamic> data)
      : userId = data['UserId'],
        type = data['Type'],
        phoneNumber = data['PhoneNumber'],
        lon = data['Lon'],
        lat = data['Lat'],
        address = data['Address'],
        name = data['Name'];

  Map<String, dynamic> toJson() {
    return {
      "UserId": userId,
      "PhoneNumber": phoneNumber,
      "Lat": lat,
      "Lon": lon,
      "Address": address,
      "Type": type
    };
  }
}
