import 'package:local_auth/local_auth.dart';

class Authentication {
  static final _auth = LocalAuthentication();

  static Future<bool> canAuthenticate() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  static Future<bool> authentication() async {
    try {
      if (!await canAuthenticate()) return false;
      return await _auth.authenticate(localizedReason: "Get into the app");
    } catch (e) {
      print("Authentication failed $e");
      return false;
    }
  }
}
