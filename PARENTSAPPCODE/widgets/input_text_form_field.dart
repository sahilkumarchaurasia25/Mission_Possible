import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  final String labelText;
  final Function(String) onSaved;
  final String regex;
  final bool obscureText;
  Icon? prefix_icon;
  Icon? suffix_icon;
  InputFormField(
      {super.key,
      required this.labelText,
      required this.onSaved,
      required this.regex,
      required this.obscureText,
      this.prefix_icon,
      this.suffix_icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        onSaved: (newValue) => onSaved(newValue!),
        decoration: InputDecoration(
            prefixIcon: prefix_icon,
            labelText: labelText,
            suffixIcon: suffix_icon,
            // hintText: labelText,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            border: Theme.of(context).inputDecorationTheme.border,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
            focusedErrorBorder:
                Theme.of(context).inputDecorationTheme.focusedErrorBorder),
        obscureText: obscureText,
        focusNode: FocusNode(),
        validator: (value) {
          return RegExp(regex).hasMatch(value!) ? null : "Enter a valid value!";
        },
      ),
    );
  }
}
