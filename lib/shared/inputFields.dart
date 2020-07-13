import 'package:flutter/material.dart';
import './colors.dart';
import './styles.dart';
import 'package:email_validator/email_validator.dart';

Container TextInput(String hintText,String defaultValue,
    {onTap, onChanged, onEditingComplete, validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      cursorColor: primaryColor,
      style: inputFieldTextStyle,
      initialValue: defaultValue,
      //validator: validator == null ?? (value) => value.isEmpty ? "Please enter value" : null,
      validator: (value) => value.isEmpty ? "Please enter value" :null,
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


Container TextPhoneInput(String hintText,String defaultValue,
    {onTap, onChanged, onEditingComplete, validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      cursorColor: primaryColor,
      style: inputFieldTextStyle,
      validator:  (value) => validateMobile(value),
      initialValue: defaultValue,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container TextAddressInput(String hintText,String defaultValue,
    {onTap, onChanged, onEditingComplete, validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      cursorColor: primaryColor,
      style: inputFieldTextStyle,
      validator:  (value) => value.isEmpty ? "Please enter value" :null,
      maxLines: 4,
      initialValue: defaultValue,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}


String validateMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  }
  else if (value.length != 10) {
    return 'Please enter 10 digit mobile number';
  }
  else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  else
    return null;
}