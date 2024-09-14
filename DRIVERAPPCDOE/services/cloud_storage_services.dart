import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String DRIVER_COLLECTION = "driver";
const String STUDENT_LIST_COLLECTION = "student_list";

class CloudStorageServices{
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  
  CloudStorageServices();

  Future<String?> saveUserImageToStorage(String uid,PlatformFile file) async{
    try {
      Reference ref = _firebaseStorage.ref().child('images/driver/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(File(file.path!));
      return task.then((result) =>result.ref.getDownloadURL());
    } catch (e) {
      print("Exception:$e");
    }
    return null;
  }

  

}