import 'package:flutter/material.dart';

Widget defaultTextField(TextEditingController controller, TextInputType type,
    Icon prefix, Function validate, String lable,
    {Function onTap}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    validator: validate,
    onTap: onTap,
    decoration: InputDecoration(
      prefixIcon: prefix,
      labelText: lable,
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
  );
}
