import 'package:drivers_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OtpVerified extends StatefulWidget {
  const OtpVerified({super.key});

  @override
  State<OtpVerified> createState() => _OtpVerifiedState();
}

class _OtpVerifiedState extends State<OtpVerified> {
  late double _deviceHeight, _devicWidth; 
  @override
  void initState() {
     super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage())); // Navigate to NextPage
    });
  }

  @override
  Widget build(BuildContext context) {
_deviceHeight = MediaQuery.of(context).size.height;
_devicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/animations/verified.json',
                  repeat: false,
                  height: _deviceHeight * 0.4,
                  width: _devicWidth * 0.6,
                ),
              ),
              Text(
                "OTP Verfied",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              
              SizedBox(
                height: 0.03 * _deviceHeight,
              ),
              const CircularProgressIndicator.adaptive()
            ],
          ),
        ),
      ),
    );
  }
}
