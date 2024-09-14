import 'package:flutter/material.dart';

class NavigationServices {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  void removeNavigateFromRoute(String route) {
    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void NavigateToRoute(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  void NavigateToPage(Widget page) {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (BuildContext context) => page));
  }

   String? getCurrentRoute() {
    return ModalRoute.of(navigatorKey.currentState!.context)?.settings.name!;
  }
  void goBack(){
    navigatorKey.currentState?.pop();
  }
}
