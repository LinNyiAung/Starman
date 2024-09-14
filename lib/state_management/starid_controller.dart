import 'package:starman/models/starid_model.dart';

class RegisterController {
  final RegisterModel _model = RegisterModel();

  RegisterModel get model => _model;

  void updateStarID(String value) {
    _model.starID = value;
  }

  void submitForm() {
    //print('Form Submitted: ${_model.toString()}');
  }
}
