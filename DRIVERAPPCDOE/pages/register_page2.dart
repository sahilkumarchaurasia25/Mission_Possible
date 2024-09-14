import 'package:drivers_app/globals.dart';
import 'package:drivers_app/providers/authentication_provider.dart';
import 'package:drivers_app/services/cloud_storage_services.dart';
import 'package:drivers_app/services/database_service.dart';
import 'package:drivers_app/services/navigation_services.dart';
import 'package:drivers_app/widgets/input_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage2 extends StatefulWidget {
  String? email;
  String? phone;
  String? name;
  String? password;
  PlatformFile? image;
  RegisterPage2(
      {super.key,
      this.email,
      this.phone,
      this.name,
      this.password,
      this.image});
  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  late double _deviceHeight, _devicWidth;
  late AuthenticationProvider _auth;
  late NavigationServices _navigation;
  late CloudStorageServices _storage;
  late DatabaseService _db;
  String? _license;
  String? _addressLine1;
  String? _addressLine2;
  String? _city;
  String? _state;
  String? _pincode;
  final GlobalKey<FormState> _register2FormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationServices>();
    _storage = GetIt.instance.get<CloudStorageServices>();
    _db = GetIt.instance.get<DatabaseService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 0.05 * _deviceHeight,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/logos/bus_logo.png',
                      height: 0.2 * _deviceHeight,
                      width: 0.2 * _deviceHeight,
                    ),
                  ),
                  Text(
                    "Let's create your account",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "Welcome to a new way of your child's safety",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 0.05 * _deviceHeight,
                  ),
                  InputFormField(
                      labelText: "Driver's License",
                      prefix_icon: const Icon(Icons.description),
                      suffix_icon: const Icon(Icons.check),
                      onSaved: (value) {
                        setState(() {
                          _license = value;
                        });
                      },
                      regex: r"^DL\d{2}\d{4}\d{7}$",
                      obscureText: false),
                  InputFormField(
                      labelText: "Address Line 1",
                      prefix_icon: const Icon(Icons.home),
                      suffix_icon: const Icon(Icons.check),
                      onSaved: (value) {
                        setState(() {
                          _addressLine1 = value;
                        });
                      },
                      regex: r"^\\p{L}+[\\p{L}\\p{Z}\\p{P},/-]*$",
                      obscureText: false),
                  InputFormField(
                      labelText: "Address Line 2",
                      prefix_icon: const Icon(Icons.home),
                      suffix_icon: const Icon(Icons.visibility),
                      onSaved: (value) {
                        setState(() {
                          _addressLine2 = value;
                        });
                      },
                      regex: r"^\\p{L}+[\\p{L}\\p{Z}\\p{P},/-]*$",
                      obscureText: false),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 0.46 * _devicWidth,
                        child: InputFormField(
                            labelText: "City",
                            prefix_icon: const Icon(Icons.place),
                            suffix_icon: const Icon(Icons.check),
                            onSaved: (value) {
                              setState(() {
                                _city = value;
                              });
                            },
                            regex: r"^\\p{L}+[\\p{L}\\p{Z}\\p{P}]{0,}",
                            obscureText: false),
                      ),
                      // SizedBox(width: 1,),
                      SizedBox(
                        width: 0.46 * _devicWidth,
                        child: InputFormField(
                            labelText: "State",
                            prefix_icon: const Icon(Icons.place),
                            suffix_icon: const Icon(Icons.arrow_downward),
                            onSaved: (value) {
                              setState(() {
                                _state = value;
                              });
                            },
                            regex: r"^\\p{L}+[\\p{L}\\p{Z}\\p{P}]{0,}",
                            obscureText: false),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  InputFormField(
                      labelText: "Pincode",
                      prefix_icon: const Icon(Icons.place),
                      suffix_icon: const Icon(Icons.check),
                      onSaved: (value) {
                        setState(() {
                          _pincode = value;
                        });
                      },
                      regex: r"^\\p{L}+[\\p{L}\\p{Z}\\p{P}]{0,}",
                      obscureText: false),
                ],
              ),
            ),
            SizedBox(
              height: 0.03 * _deviceHeight,
            ),
            _registerButton(),
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

  Widget _registerButton() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: darkBlue),
        child: TextButton(
          onPressed: _registerUser,
          child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Icon(
                  Icons.login,
                  size: 26,
                  color: Colors.white,
                ),
              ]),
        ));
  }

  void _registerUser() {
    if (_register2FormKey.currentState!.validate() && widget.image != null) {
      _register2FormKey.currentState!.save();
      String? uid = _auth.registerUserUsingEmailAndPassword(
          widget.email!, widget.password!) as String?;
      String? imageURL =
          _storage.saveUserImageToStorage(uid!, widget.image!) as String?;
      _db.createUser(
        widget.name!,
        widget.email!,
        uid,
        imageURL!,
        widget.phone!,
        _license!,
        _addressLine1!,
        _addressLine2!,
        _city!,
        _state!,
        _pincode!,
      );
      _auth.logout();
      _auth.loginUsingEmailAndPassword(widget.email!, widget.password!);
    }
  }
}
