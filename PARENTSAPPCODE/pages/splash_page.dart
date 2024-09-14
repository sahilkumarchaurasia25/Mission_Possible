import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parents_app/services/cloud_storage_services.dart';
import 'package:parents_app/services/database_service.dart';
import 'package:parents_app/services/media_services.dart';
import 'package:parents_app/services/navigation_services.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitialisationComplete;
  const SplashPage({super.key, required this.onInitialisationComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((_) => _setupAndNavigate());
  }

  Future<void> _setupAndNavigate() async {
    await _setup(); // Ensure setup completes
    widget.onInitialisationComplete(); // Navigate to MainApp after setup
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Parents",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/logos/bus_logo.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationServices>(NavigationServices());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance
        .registerSingleton<CloudStorageServices>(CloudStorageServices());
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  }
}
