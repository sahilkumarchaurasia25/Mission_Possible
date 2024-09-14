import 'package:cloud_firestore/cloud_firestore.dart';

const String PARENT_COLLECTION = "parent";
const String CHILD_LIST_COLLECTIONS = "child_list";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService();

  Future<void> createUser(
    String name,
    String email,
    String uid,
    String imageURL,
    String phone,
    String childCount,
  ) async {
    try {
      await _db.collection(PARENT_COLLECTION).doc(uid).set({
        "name": name,
        "email": email,
        "phone": phone,
        "imageURL": imageURL,
        "childCount": childCount
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection(PARENT_COLLECTION).doc(uid).get();
  }

  Future<void> getChildIdsForUser(String userId) async {
    CollectionReference childListCollection = _db
        .collection(PARENT_COLLECTION)
        .doc(userId)
        .collection(CHILD_LIST_COLLECTIONS);
    QuerySnapshot querySnapshot = await childListCollection.get();
    for (var doc in querySnapshot.docs) {
      String childId = doc.id;
      print('Chat ID: $childId');
    }
  }
}
