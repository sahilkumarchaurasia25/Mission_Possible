import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:parents_app/pages/home_page.dart';
import 'package:parents_app/pages/login_page.dart';
import 'package:parents_app/pages/splash_page.dart';
import 'package:parents_app/providers/authentication_provider.dart';
import 'package:parents_app/services/navigation_services.dart';
import 'package:provider/provider.dart';

void main() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: "Notification channels for basic test"),
      ],
      debug: true);
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
        },
        initialRoute: '/login',
        home: const LoginPage(),
      ),
    );
  }
}

