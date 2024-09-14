import 'package:flutter/material.dart';
import 'package:starman/state_management/passcode_controller.dart';
import 'package:starman/views/confirm_passcode_view.dart';
import 'package:starman/widgets/passcode_pad_widget.dart';

class PasscodeView extends StatefulWidget {
  @override
  _PasscodeViewState createState() => _PasscodeViewState();
}

class _PasscodeViewState extends State<PasscodeView> {
  final PasscodeController _controller = PasscodeController();
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _textControllers =
      List.generate(4, (_) => TextEditingController());

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

  void _navigateToConfirmPasscode() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            ConfirmPasscodeScreen(tempPasscode: _controller.getPasscode())));
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

  void _onPasscodeComplete() async {
    if (_controller.isPasscodeComplete()) {
      await _controller.savePasscode();
      _navigateToConfirmPasscode();
    } else {
      _showError('Please enter a 4-digit passcode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Image.asset(
          //   'assets/starman_bg.png',
          //   fit: BoxFit.cover,
          // ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Set Your Passcode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 80),
                  Text(
                    'Please enter a 4-digit passcode',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 100),
                  PasscodePadWidget(
                    controller: _controller,
                    focusNodes: _focusNodes,
                    textControllers: _textControllers,
                    onCompleted: _onPasscodeComplete,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
