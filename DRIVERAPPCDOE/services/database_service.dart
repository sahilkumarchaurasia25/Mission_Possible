import 'package:cloud_firestore/cloud_firestore.dart';

const String DRIVER_COLLECTION = "driver";
const String TODAY_RIDE_COLLECTION = "today_ride";
const String STUDENT_LIST_COLLECTION = "student_list";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService();

  Future<void> createUser(
    String name,
    String email,
    String uid,
    String imageURL,
    String phone,
    String license,
    String addressLine1,
    String addressLine2,
    String city,
    String state,
    String pincode,
  ) async {
    try {
      await _db.collection(DRIVER_COLLECTION).doc(uid).set({
        "name": name,
        "email": email,
        "phone": phone,
        "imageURL": imageURL,
        "license": license,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "pincode": pincode,
        "total_ride": "0",
        "total_students_dropped": "0"
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection(DRIVER_COLLECTION).doc(uid).get();
  }

  Future<QuerySnapshot> getTodaysRideDetails(String uid) {
    return _db
        .collection(DRIVER_COLLECTION)
        .doc(uid)
        .collection(TODAY_RIDE_COLLECTION)
        .orderBy("date")
        .limit(1)
        .get();
  }
}
