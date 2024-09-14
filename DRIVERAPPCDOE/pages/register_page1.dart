import 'package:drivers_app/pages/register_page2.dart';
import 'package:drivers_app/services/media_services.dart';
import 'package:drivers_app/widgets/input_text_form_field.dart';
import 'package:drivers_app/widgets/rounded_image.dart';
import 'package:drivers_app/widgets/submit_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({super.key});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  late double _deviceHeight, _devicWidth;
  String? _email;
  String? _phone;
  String? _name;
  String? _password;
  PlatformFile? _image;
  final GlobalKey<FormState> _register1FormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(children: [
                  SizedBox(
                  height: 0.05 * _deviceHeight,
                ),
                Image.asset(
                  'assets/logos/bus_logo.png',
                  height: 0.2 * _deviceHeight,
                  width: 0.2 * _deviceHeight,
                ),
                Text(
                  "Let's create your account",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Welcome to a new way of your child's safety",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                _profileImageField(),
                SizedBox(
                  height: 0.05 * _deviceHeight,
                ),
                _formField(),
                ],),
              ),
              SizedBox(
                height: 0.03 * _deviceHeight,
              ),
              SubmitButton(
                  text: "Next", icon: Icons.login, func: () => _register1User()),
              SizedBox(
                height: 0.04 * _deviceHeight,
              ),
              SizedBox(
                height: 0.05 * _deviceHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (file) {
            setState(
              () {
                _image = file;
              },
            );
          },
        );
      },
      child: () {
        if (_image != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _image!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath: "https://i.pravatar.cc/150?img=65",
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _formField() {
    return SizedBox(
      child: Form(
        key: _register1FormKey,
        child: Column(
          children: [
            InputFormField(
                labelText: "Name",
                prefix_icon: const Icon(Icons.description),
                suffix_icon: const Icon(Icons.check),
                onSaved: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                regex: r"^[a-zA-Z]+([ '-][a-zA-Z]+)*$",
                obscureText: false),
            InputFormField(
                labelText: "Phone Number",
                prefix_icon: const Icon(Icons.phone),
                suffix_icon: const Icon(Icons.check),
                onSaved: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
                regex: r'(^(?:[+0]9)?[0-9]{10,12}$)',
                obscureText: false),
            InputFormField(
                labelText: "Email",
                prefix_icon: const Icon(Icons.mail),
                suffix_icon: const Icon(Icons.visibility),
                onSaved: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                regex:
                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                obscureText: false),
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
        ),
      ),
    );
  }

  void _register1User() {
    if (_register1FormKey.currentState!.validate()) {
      _register1FormKey.currentState!.save();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => RegisterPage2(email: _email,name: _name,phone: _phone,password: _password,image: _image,)));
    }
  }
}
