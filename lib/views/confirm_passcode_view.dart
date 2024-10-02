import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/state_management/passcode_controller.dart';
import 'package:starman/views/home_view.dart';
import 'package:starman/views/passcode_view.dart';
import 'package:starman/views/report_view/cf_report_view.dart';
import 'package:starman/views/report_view/exp_report_view.dart';
import 'package:starman/views/report_view/ns_report_view.dart';
import 'package:starman/views/report_view/os_report_view.dart';
import 'package:starman/views/report_view/pi_report_view.dart';
import 'package:starman/views/report_view/profitlost_report_view.dart';
import 'package:starman/views/report_view/rs_report_view.dart';
import 'package:starman/views/report_view/sb_report_view.dart';
import 'package:starman/views/report_view/si_report_view.dart';
import 'package:starman/widgets/loading_widget.dart';
import 'package:starman/widgets/passcode_pad_widget.dart';

class ConfirmPasscodeScreen extends StatefulWidget {
  final String tempPasscode;

  ConfirmPasscodeScreen({required this.tempPasscode});

  @override
  _ConfirmPasscodeScreenState createState() => _ConfirmPasscodeScreenState();
}

class _ConfirmPasscodeScreenState extends State<ConfirmPasscodeScreen> {
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

  Future<void> _savePasscode(String passcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('passcode', passcode);
  }

  void _validatePasscode() async {
    if (_controller.getPasscode() == widget.tempPasscode) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(Duration(seconds: 2));

      await _savePasscode(_controller.getPasscode());

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfitLostReportView()));
    } else {
      _showError('Passcodes do not match');
      _clearPasscodeFields();
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
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

  void _navigateBackToPasscodeView() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PasscodeView()),
    );
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
                    'Confirm Passcode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 80),
                  SizedBox(height: 10),
                  Text(
                    'Re-enter Passcode',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 100),
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
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: LoadingOverlay(message: 'Loading...'),
            ),
          // IconButton
          Positioned(
            top: 30, // Adjust as needed
            left: 10, // Adjust as needed
            child: IconButton(
              onPressed: _navigateBackToPasscodeView,
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
