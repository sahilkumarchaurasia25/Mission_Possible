class ChildUser {
  final String childId;
  final String child_name;
  final String status;

  ChildUser(
      {required this.childId, required this.child_name, required this.status});

  factory ChildUser.fromJson(Map<String, dynamic> json) {
    return ChildUser(
        childId: json["childId"],
        child_name: json["child_name"],
        status: json["status"]);
  }
}
