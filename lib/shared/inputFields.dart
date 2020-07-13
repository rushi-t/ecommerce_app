import 'package:flutter/material.dart';
import './colors.dart';
import './styles.dart';
import 'package:email_validator/email_validator.dart';

Container TextInput(String hintText,
    {onTap, onChanged, onEditingComplete, validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      cursorColor: primaryColor,
      style: inputFieldTextStyle,
      validator: validator == null ?? (value) => value.isEmpty ? "Please enter value" : null,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container EmailInput(String hintText,
    {onTap, onChanged, onEditingComplete}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      keyboardType: TextInputType.emailAddress,
      cursorColor: primaryColor,
      style: inputFieldTextStyle,
      validator: (email) => !EmailValidator.validate(email) ? 'Please enter valid email' : null,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}


Container PasswordInput(String hintText,
    {onTap, onChanged, onEditingComplete}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      obscureText: true,
      cursorColor: primaryColor,
      style: inputFieldHintPaswordTextStyle,
      validator: (password) => password.length < 6 ? 'Please should be more than 6 characters' : null,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintPaswordTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}
