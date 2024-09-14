class ParentUser {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  final String phone;
  final String childCount;

  ParentUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.imageURL,
      required this.phone,
      required this.childCount});

  factory ParentUser.fromJson(Map<String, dynamic> json) {
    return ParentUser(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        imageURL: json["imageURL"],
        phone: json["phone"],
        childCount: json["childCount"]);
  }
}
