

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parents_app/services/database_service.dart';
import 'package:parents_app/services/navigation_services.dart';

class ChildListProvider extends ChangeNotifier{
  late final FirebaseAuth _auth;
  late final NavigationServices _navigationService;
  late final DatabaseService _databaseService;

  ChildListProvider(){
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationServices>();
    _databaseService = GetIt.instance.get<DatabaseService>();

  }

  Future<void> 
}