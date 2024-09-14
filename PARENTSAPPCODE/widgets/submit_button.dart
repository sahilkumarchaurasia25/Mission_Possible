import 'package:flutter/material.dart';
import 'package:parents_app/globals.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final Function func;
  final IconData icon;
  const SubmitButton({
    super.key,
    required this.text,
    required this.icon,
    required this.func,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: darkBlue),
        child: TextButton(
          onPressed: () => func(),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Icon(
                  icon,
                  size: 26,
                  color: Colors.white,
                ),
              ]),
        ));
  }
}
