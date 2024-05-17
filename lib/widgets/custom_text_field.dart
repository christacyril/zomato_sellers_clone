import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true;
  bool? enabled = true;
  final ValueChanged<String>? onChanged;

  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecre,
    this.enabled,
    this.onChanged,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.all(0),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).primaryColor,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
    width: 1, color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    );
  }
}
