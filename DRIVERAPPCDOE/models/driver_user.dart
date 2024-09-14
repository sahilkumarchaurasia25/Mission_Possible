
class DriverUser {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  final String phone;
  final String license;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String total_ride;
  final String total_students_dropped;

  DriverUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.imageURL,
      required this.phone,
      required this.license,
      required this.addressLine1,
      required this.addressLine2,
      required this.city,
      required this.state,
      required this.pincode,
      required this.total_ride,
      required this.total_students_dropped});

  factory DriverUser.fromJson(Map<String, dynamic> json) {
    return DriverUser(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        imageURL: json["imageURL"],
        phone: json["phone"],
        license: json["license"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        total_ride: json["total_ride"],
        total_students_dropped: json["total_students_dropped"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "imageURL": imageURL,
      "total_ride": total_ride,
      "total_students_dropped": total_students_dropped
    };
  }
}
