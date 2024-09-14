import 'package:drivers_app/globals.dart';
import 'package:drivers_app/pages/register_page1.dart';
import 'package:drivers_app/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPageLink extends StatelessWidget {
  RegisterPageLink({
    super.key,
  });
    late NavigationServices _navigation;
  @override
  Widget build(BuildContext context) {
    _navigation = GetIt.instance.get<NavigationServices>();
    return GestureDetector(
      onTap: () => _navigation.NavigateToPage(const RegisterPage1()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Create New Account",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Icon(
            Icons.person_add_alt_1,
            color: darkBlue,
          )
        ],
      ),
    );
  }
}
