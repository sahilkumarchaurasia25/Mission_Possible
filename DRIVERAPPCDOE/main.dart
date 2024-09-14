import 'package:drivers_app/pages/home_page.dart';
import 'package:drivers_app/pages/login_page.dart';
import 'package:drivers_app/pages/register_page1.dart';
import 'package:drivers_app/pages/splash_page.dart';
import 'package:drivers_app/providers/authentication_provider.dart';
import 'package:drivers_app/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitialisationComplete: () {
      runApp(const MyApp());
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (BuildContext context) => AuthenticationProvider())
      ],
      child: MaterialApp(
        title: 'Driver App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        navigatorKey: NavigationServices.navigatorKey,
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/home': (BuildContext context) => const HomePage(),
          '/register': (BuildContext context) => const RegisterPage1(),
        },
        initialRoute: '/login',
        home: const LoginPage(),
      ),
    );
  }
}
