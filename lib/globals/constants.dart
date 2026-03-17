import 'package:flutter/material.dart';

//    Constants
const kAppName = "SBTS Parent";
const kAssets = "assets/images";
const kEnglishLocale = "en_US";
const kNetworkErrMsg = "Please check you network connection and try again.";
const kGeneralErrMsg = "Something went wrong. Please try again later.";
const kServerErrMsg = "This function is not supported in this message";
const kShowGenericErrorMsg = true;
const kSuppressErrors = true;

//    Fonts
const kPoppins = "Poppins";

//    Settings
const double kNavBarHeight = 48;
const Duration kSnackbarDuration = Duration(seconds: 3);
const Duration kAnimationDuration = Duration(milliseconds: 100);
const BoxConstraints kMaxWidthConstraints = BoxConstraints(maxWidth: 550);

//    Colors
const Color kPrimaryColor = kIndigo;
const Color kIndigo = Color(0xFF5B6CFF);
const Color kDarkIndigo = Color(0xff2D314D);
const Color kTangerine = Color(0xffffa165);
const Color kOrange = Color(0xffFF7B02);
const Color kRed = Color(0xffD51150);
const Color kYellow = Color(0xffFAD305);
const Color kAmber = Color(0xFFFFC107);
const Color kGreen = Color(0xff61DA6E);
const Color kErrorColor = Color(0xffEB4D4B);
const Color kBlack = Color(0xff000000);
const Color kLightBlack = Color(0xff323336);
const Color kGrey = Color(0xFF9E9E9E);
const Color kMidGrey = Color(0xFFBEBEBE);
const Color kLightGrey = Color(0xffE6E6E6);
const Color kDarkGrey = Color(0xff6C6C6C);
const Color kBgColor = Color(0xffFFFFFF);
const Color kScaffoldBg = Color(0xFFF5F6FA);
const Color kNavColor = Color(0xff151D28);
const Color kFillColor = Color(0xff1E2431);

//    TextStyles
const TextStyle kSmallHeading = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
const TextStyle kSubtitleStyle = TextStyle(fontSize: 13, color: kGrey);

//    BorderRadius
final BorderRadius kBorderRadius4 = BorderRadius.circular(4);
final BorderRadius kBorderRadius6 = BorderRadius.circular(6);
final BorderRadius kBorderRadius8 = BorderRadius.circular(8);
final BorderRadius kBorderRadius12 = BorderRadius.circular(12);
final BorderRadius kBorderRadius16 = BorderRadius.circular(16);
final BorderRadius kBorderRadius20 = BorderRadius.circular(20);
final BorderRadius kBorderRadius24 = BorderRadius.circular(24);

//    Gradients
const LinearGradient kAppGradient = kIndigoAppGradient;
const LinearGradient kIndigoAppGradient = LinearGradient(colors: [Color(0xff2D314D), Color(0xff27263A)], begin: Alignment.centerLeft, end: Alignment.centerRight);
const LinearGradient kTealAppGradient = LinearGradient(colors: [Color(0xff21DFC5), Color(0xff01A9B3)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
const LinearGradient kRedAppGradient = LinearGradient(colors: [Color(0xffFF512F), Color(0xffDD2476)], begin: Alignment.centerLeft, end: Alignment.centerRight);
const LinearGradient kYellowAppGradient = LinearGradient(colors: [kYellow, kAmber], begin: Alignment.topCenter, end: Alignment.bottomCenter);

//    Box Shadow
const BoxShadow kComponentShadow = BoxShadow(spreadRadius: 0.1, blurRadius: 12, color: Color(0xffEFEFEF));
final BoxShadow kCardsShadow = BoxShadow(color: const Color(0xff444444).withValues(alpha: 0.20), offset: const Offset(0, 12), blurRadius: 24);
final BoxShadow kCardsShadow2 = BoxShadow(color: const Color(0xff444444).withValues(alpha: 0.10), offset: const Offset(0, 10), blurRadius: 24);
final BoxShadow kLightShadow = BoxShadow(color: const Color(0xffD0D0D6).withValues(alpha: 0.48), offset: const Offset(0, 4), blurRadius: 9);
