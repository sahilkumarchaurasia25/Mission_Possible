//Packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:parents_app/globals.dart';
import 'package:parents_app/models/parent_user.dart';
import 'package:parents_app/services/navigation_services.dart';

//Services
import '../services/database_service.dart';

//Models

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationServices _navigationService;
  late final DatabaseService _databaseService;

  

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationServices>();
    _databaseService = GetIt.instance.get<DatabaseService>();

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _databaseService.getUser(user.uid).then(
          (snapshot) {
            Map<String, dynamic> userData =
                snapshot.data()! as Map<String, dynamic>;
                print(userData);
            parentUser  = ParentUser.fromJson(
              {
                "uid": user.uid,
                "name": userData["name"],
                "email": userData["email"],
                "imageURL": userData["imageURL"],
                "phone":userData["phone"],
                "childCount":userData["childCount"]
                
              },
            );
            print("Successful");
            _navigationService.removeNavigateFromRoute('/home');
          },
        );
      } else {
        if (_navigationService.getCurrentRoute() != '/login') {
          _navigationService.removeNavigateFromRoute('/login');
          print("Unsuccessful");
        }
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException {
      print("Error logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user!.uid;
    } on FirebaseAuthException {
      print("Error registering user.");
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
