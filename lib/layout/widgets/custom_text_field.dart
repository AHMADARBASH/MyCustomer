// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String? hint;
  bool? isPassword;
  FormFieldValidator<String>? validator;
  TextEditingController? controller;
  FormFieldSetter<String>? onsaved;
  TextInputAction? textAction;
  Color? borderColor;
  Color? disbledBorderColor;
  VoidCallback? onEditingComplete;
  VoidCallback? passwordFunction;
  bool? isPasswordRevealed;
  bool? isEnabled = true;
  TextInputType? keyboardType;
  CustomTextField({
    Key? key,
    this.hint,
    this.onEditingComplete,
    this.isPassword,
    this.validator,
    this.controller,
    this.onsaved,
    this.textAction,
    this.isEnabled,
    this.borderColor = Colors.grey,
    this.disbledBorderColor = Colors.grey,
    this.passwordFunction,
    this.isPasswordRevealed,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      enabled: isEnabled,
      onEditingComplete: onEditingComplete,
      onSaved: onsaved,
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textInputAction: textAction,
      obscureText: isPasswordRevealed ?? false,
      decoration: InputDecoration(
        floatingLabelStyle:
            TextStyle(color: Theme.of(context).colorScheme.secondary),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: disbledBorderColor!),
        ),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: Text(hint ?? ""),
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: borderColor!),
        ),
        focusColor: Theme.of(context).colorScheme.secondary,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      validator: validator,
    );
  }
}
