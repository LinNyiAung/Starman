import 'package:shared_preferences/shared_preferences.dart';

class PasscodeController {
  String _passcode = '';
  String? tempPasscode;

  void updatePasscode(String value, int index) {
    if (value.length == 1) {
      if (_passcode.length == index) {
        _passcode += value;
      } else {
        _passcode = _passcode.substring(0, index) +
            value +
            _passcode.substring(index + 1);
      }
    }
  }

  bool isPasscodeComplete() {
    return _passcode.length == 4;
  }

  String getPasscode() {
    return _passcode;
  }

  void clearPasscode() {
    _passcode = '';
  }

  void setTempPasscode(String passcode) {
    tempPasscode = passcode;
  }

  String? getTempPasscode() {
    return tempPasscode;
  }

  Future<void> savePasscode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_passcode', _passcode);
  }

  Future<String?> retrievePasscode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_passcode');
  }

  Future<bool> isPasscodeCorrect() async {
    String? savedPasscode = await retrievePasscode();
    return savedPasscode == _passcode;
  }
}
