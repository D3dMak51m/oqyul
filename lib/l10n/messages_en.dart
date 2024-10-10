// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  static m0(phoneNumber) => "Enter the code sent to the number ${phoneNumber}";

  static m1(time) => "Premium expires in ${time}";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'appName': MessageLookupByLibrary.simpleMessage('Oqyul'),
    'cancel': MessageLookupByLibrary.simpleMessage('Cancel'),
    'carNumber': MessageLookupByLibrary.simpleMessage('Car Number'),
    'codeResent': MessageLookupByLibrary.simpleMessage('Code resent.'),
    'confirmPassword': MessageLookupByLibrary.simpleMessage('Confirm Password'),
    'darkMode': MessageLookupByLibrary.simpleMessage('Dark Mode'),
    'databaseUpdated': MessageLookupByLibrary.simpleMessage('Database updated successfully'),
    'disableDrivingMode': MessageLookupByLibrary.simpleMessage('Disable Driving Mode'),
    'disableSound': MessageLookupByLibrary.simpleMessage('Disable Sound'),
    'enableDrivingMode': MessageLookupByLibrary.simpleMessage('Enable Driving Mode'),
    'enableSound': MessageLookupByLibrary.simpleMessage('Enable Sound'),
    'error': MessageLookupByLibrary.simpleMessage('Error'),
    'errorLoadingMap': MessageLookupByLibrary.simpleMessage('Error loading map'),
    'errorLoadingSettings': MessageLookupByLibrary.simpleMessage('Error loading settings'),
    'errorLoadingUserData': MessageLookupByLibrary.simpleMessage('Error loading user data'),
    'forgotPassword': MessageLookupByLibrary.simpleMessage('Forgot password?'),
    'fullName': MessageLookupByLibrary.simpleMessage('Full Name'),
    'homeTitle': MessageLookupByLibrary.simpleMessage('Home'),
    'invalidCarNumber': MessageLookupByLibrary.simpleMessage('Enter your car number'),
    'invalidFullName': MessageLookupByLibrary.simpleMessage('Enter your full name'),
    'invalidOtp': MessageLookupByLibrary.simpleMessage('Invalid code. Please try again.'),
    'invalidPassword': MessageLookupByLibrary.simpleMessage('Password must be at least 6 characters'),
    'invalidPhoneNumber': MessageLookupByLibrary.simpleMessage('Invalid phone number'),
    'language': MessageLookupByLibrary.simpleMessage('Interface Language'),
    'languageEnglish': MessageLookupByLibrary.simpleMessage('English'),
    'languageRussian': MessageLookupByLibrary.simpleMessage('Русский'),
    'languageUzbek': MessageLookupByLibrary.simpleMessage('Oʻzbekcha'),
    'loading': MessageLookupByLibrary.simpleMessage('Loading...'),
    'locationPermissionDenied': MessageLookupByLibrary.simpleMessage('No permission for location access'),
    'loginButton': MessageLookupByLibrary.simpleMessage('Login'),
    'loginTitle': MessageLookupByLibrary.simpleMessage('Login'),
    'myLocation': MessageLookupByLibrary.simpleMessage('My Location'),
    'notificationLanguage': MessageLookupByLibrary.simpleMessage('Notification Language'),
    'ok': MessageLookupByLibrary.simpleMessage('OK'),
    'otpInstruction': m0,
    'otpTitle': MessageLookupByLibrary.simpleMessage('OTP Verification'),
    'password': MessageLookupByLibrary.simpleMessage('Password'),
    'passwordsDoNotMatch': MessageLookupByLibrary.simpleMessage('Passwords do not match'),
    'phoneNumber': MessageLookupByLibrary.simpleMessage('Phone Number'),
    'premiumExpired': MessageLookupByLibrary.simpleMessage('Premium mode expired'),
    'premiumExpiresIn': m1,
    'premiumModalContent': MessageLookupByLibrary.simpleMessage('Get access to updated data and additional features by activating premium mode.'),
    'premiumModalTitle': MessageLookupByLibrary.simpleMessage('Premium Mode'),
    'registerButton': MessageLookupByLibrary.simpleMessage('Register'),
    'registrationTitle': MessageLookupByLibrary.simpleMessage('Registration'),
    'resendCode': MessageLookupByLibrary.simpleMessage('Resend Code'),
    'settingsTitle': MessageLookupByLibrary.simpleMessage('Settings'),
    'updateDatabase': MessageLookupByLibrary.simpleMessage('Update Database'),
    'verifyButton': MessageLookupByLibrary.simpleMessage('Verify'),
    'watchAd': MessageLookupByLibrary.simpleMessage('Watch Ad')
  };
}
