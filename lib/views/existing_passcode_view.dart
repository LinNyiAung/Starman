import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/models/exp_model/exp_model.dart';
import 'package:starman/state_management/passcode_controller.dart';
import 'package:starman/views/home_view.dart';
import 'package:starman/views/report_view/cf_daily_report_view.dart';
import 'package:starman/views/report_view/cf_report_view.dart';
import 'package:starman/views/report_view/ns_report_view.dart';
import 'package:starman/views/report_view/pi_report_view.dart';
import 'package:starman/views/report_view/profitlost_report_view.dart';
import 'package:starman/views/report_view/si_report_view.dart';
import 'package:starman/widgets/loading_widget.dart';
import 'package:starman/widgets/passcode_pad_widget.dart';

class ExistingPasscodeView extends StatefulWidget {
  @override
  _ExistingPasscodeViewState createState() => _ExistingPasscodeViewState();
}

class _ExistingPasscodeViewState extends State<ExistingPasscodeView> {
  final PasscodeController _controller = PasscodeController();
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _textControllers =
      List.generate(4, (_) => TextEditingController());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var textController in _textControllers) {
      textController.dispose();
    }
    super.dispose();
  }

  Future<bool> _isPasscodeCorrect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPasscode = prefs.getString('passcode');
    return _controller.getPasscode() == storedPasscode;
  }

  void _navigateToHome() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Show loading for 2 seconds

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfitLostReportView()));
  }

  void _validatePasscode() async {
    if (_controller.isPasscodeComplete()) {
      bool isCorrect = await _isPasscodeCorrect();
      if (isCorrect) {
        _navigateToHome();
      } else {
        _showError('Incorrect passcode. Please try again.');
        _clearPasscodeFields();
      }
    } else {
      _showError('Please enter a 4-digit passcode');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Wrong Passcode'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearPasscodeFields() {
    setState(() {
      _controller.clearPasscode();
      for (var i = 0; i < _textControllers.length; i++) {
        _textControllers[i].clear();
      }
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter Passcode To Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 80),
                  SizedBox(height: 10),
                  Text(
                    'Please enter a 4-digit passcode',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 20),
                  PasscodePadWidget(
                    controller: _controller,
                    focusNodes: _focusNodes,
                    textControllers: _textControllers,
                    onCompleted: _validatePasscode,
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: LoadingOverlay(message: 'Loading...'),
            ),
        ],
      ),
    );
  }
}
