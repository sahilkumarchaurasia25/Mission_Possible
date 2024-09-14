import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parents_app/providers/authentication_provider.dart';
import 'package:parents_app/services/cloud_storage_services.dart';
import 'package:parents_app/services/database_service.dart';
import 'package:parents_app/services/navigation_services.dart';
import 'package:parents_app/widgets/input_text_form_field.dart';
import 'package:parents_app/widgets/submit_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight, _devicWidth;
  late AuthenticationProvider _auth;
  late NavigationServices _navigation;
  late CloudStorageServices _storage;
  late DatabaseService _db;
  String? _email;
  String? _password;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    _navigation = GetIt.instance.get<NavigationServices>();
    _storage = GetIt.instance.get<CloudStorageServices>();
    _db = GetIt.instance.get<DatabaseService>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.05 * _deviceHeight,
            ),
            Image.asset(
              'assets/logos/bus_logo.png',
              height: 0.2 * _deviceHeight,
              width: 0.2 * _deviceHeight,
            ),
            Text(
              "Welcome Back",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "Welcome to a new way of your child's safety",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 0.05 * _deviceHeight,
            ),
            _formField(),
            Row(
              children: [
                Checkbox(value: true, onChanged: (value) {}),
                const Text("Remember Me")
              ],
            ),
            SizedBox(
              height: 0.03 * _deviceHeight,
            ),
            SubmitButton(text: "Login", icon: Icons.login, func: _loginUser),
            SizedBox(
              height: 0.04 * _deviceHeight,
            ),
            SizedBox(
              height: 0.05 * _deviceHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField() {
    return SizedBox(
      child: Form(
          key: _loginFormKey,
          child: Column(
            children: [
              InputFormField(
                  labelText: "Email",
                  prefix_icon: const Icon(Icons.phone),
                  suffix_icon: const Icon(Icons.check),
                  onSaved: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  regex:
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                  obscureText: false),
              const SizedBox(
                height: 1,
              ),
              InputFormField(
                  labelText: "Password",
                  prefix_icon: const Icon(Icons.key),
                  suffix_icon: const Icon(Icons.visibility),
                  onSaved: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  regex: r".{8,}",
                  obscureText: true),
            ],
          )),
    );
  }

  void _loginUser() {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      _auth.loginUsingEmailAndPassword(_email!, _password!);
    }
  }
}
