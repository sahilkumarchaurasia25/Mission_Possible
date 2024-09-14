import 'package:drivers_app/globals.dart';
import 'package:drivers_app/pages/otp_screen.dart';
import 'package:drivers_app/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

class OtpSent extends StatelessWidget {
  late double _deviceHeight, _devicWidth;
  OtpSent({super.key});
  OtpTimerButtonController controller = OtpTimerButtonController();
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
                  'assets/animations/otp_sent.json',
                  repeat: false,
                  height: _deviceHeight * 0.4,
                  width:_devicWidth * 0.6,
                ),
              ),
              Text(
                "OTP Sent",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Check your mail inbox associated to saxxxxxxxxx@gmail.com and messages to phone number 99xxxxxx97",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 0.03 * _deviceHeight,
              ),
              SubmitButton(
                  text: "Continue",
                  icon: Icons.forward,
                  func: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()))),
              SizedBox(
                height: 0.005 * _deviceHeight,
              ),
              Center(
                child: OtpTimerButton(
                  controller: controller,
                  buttonType: ButtonType.text_button,
                  onPressed: () => _requestOtp,
                  text: Text(
                    'Resend OTP',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  duration: 60,
                  loadingIndicator: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: darkBlue,
                  ),
                  loadingIndicatorColor: darkBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestOtp() {
    controller.loading();
    Future.delayed(const Duration(seconds: 2), () {
      controller.startTimer();
    });
  }
}
