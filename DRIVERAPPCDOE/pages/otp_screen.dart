import 'package:drivers_app/pages/otp_verified.dart';
import 'package:drivers_app/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});
  late double _deviceHeight, _devicWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        SizedBox(
          height: 0.05 * _deviceHeight,
        ),
        Image.asset(
          'assets/logos/bus_logo.png',
          height: 0.2 * _deviceHeight,
          width: 0.2 * _deviceHeight,
        ),
        Text(
          "OTP Verification",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        
        SizedBox(
          height: 0.05 * _deviceHeight,
        ),
        Text(
          "Enter the one time password(OTP) sent to saxxxxxxxxx@gmxxx.com",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 0.03 * _deviceHeight,
        ),
        OtpTextField(
          mainAxisAlignment: MainAxisAlignment.center,
          numberOfFields: 6,
          borderColor: Colors.grey,
          borderRadius: BorderRadius.circular(8),
          fillColor: Colors.transparent,
          filled: true,
          obscureText: true,
          onSubmit: (value) {
            print("OTP is => $value");
          },
        ),
        SizedBox(
          height: 0.08 * _deviceHeight,
        ),
        SizedBox(
          height: 0.03 * _deviceHeight,
        ),
        Text(
          "Enter the one time password(OTP) sent to 99xxxxxx97",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 0.03 * _deviceHeight,
        ),
        OtpTextField(
          mainAxisAlignment: MainAxisAlignment.center,
          numberOfFields: 6,
          borderColor: Colors.grey,
          borderRadius: BorderRadius.circular(8),
          fillColor: Colors.transparent,
          filled: true,
          onSubmit: (value) {
            print("OTP is => $value");
          },
        ),
        SizedBox(
          height: 0.08 * _deviceHeight,
        ),
        SubmitButton(
            text: "Verify",
            icon: Icons.check_circle,
            func: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OtpVerified()),
                (Route<dynamic> route) => false))
      ]),
    ));
  }
}
