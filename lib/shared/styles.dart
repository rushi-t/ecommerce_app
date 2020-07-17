import 'package:flutter/material.dart';
import './colors.dart';

/////////////////////////////////
///   TEXT STYLES
////////////////////////////////

const logoStyle = TextStyle(fontFamily: 'Pacifico', fontSize: 30, color: Colors.black54, letterSpacing: 2);

const logoWhiteStyle = TextStyle(fontFamily: 'Pacifico', fontSize: 21, letterSpacing: 2, color: Colors.white);
const whiteText = TextStyle(color: Colors.white,);
const disabledText = TextStyle(color: Colors.grey, );
const contrastText = TextStyle(color: primaryColor,);
const contrastTextBold = TextStyle(color: primaryColor, fontWeight: FontWeight.w600);

const h3 = TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800, );

const h4 = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Poppins');

const h5 = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Poppins');

const h6 = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins');

const primaryTextStyle = TextStyle(
  color: primaryColor,
  fontSize: 16,
  fontWeight: FontWeight.w200,
);

const primaryTextStyleDark = TextStyle(color: primaryColorDark, fontSize: 16, fontWeight: FontWeight.w800);

const tabLinkStyle = TextStyle(fontWeight: FontWeight.w500);

const taglineText = TextStyle(color: Colors.grey, fontFamily: 'Poppins');
const categoryText = TextStyle(color: Color(0xff444444), fontWeight: FontWeight.w700, fontFamily: 'Poppins');

const inputFieldTextStyle = TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500);

const inputFieldHintTextStyle = TextStyle(fontFamily: 'Poppins', color: Color(0xff444444));

const inputFieldPasswordTextStyle = TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, letterSpacing: 3);

const inputFieldHintPaswordTextStyle = TextStyle(fontFamily: 'Poppins', color: Color(0xff444444), letterSpacing: 2);

///////////////////////////////////
/// BOX DECORATION STYLES
//////////////////////////////////

const authPlateDecoration = BoxDecoration(
    color: white,
    boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, .1), blurRadius: 10, spreadRadius: 5, offset: Offset(0, 1))],
    borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(20), bottomStart: Radius.circular(20)));

/////////////////////////////////////
/// INPUT FIELD DECORATION STYLES
////////////////////////////////////

const inputFieldFocusedBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    borderSide: BorderSide(
      color: primaryColor,
    ));

const inputFieldDefaultBorderStyle = OutlineInputBorder(gapPadding: 0, borderRadius: BorderRadius.all(Radius.circular(6)));

const cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(0)),
  boxShadow: [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, .1),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);
