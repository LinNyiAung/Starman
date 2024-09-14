import 'package:flutter/material.dart';
import 'package:starman/main.dart';
import 'package:starman/state_management/passcode_controller.dart';

class PasscodePadWidget extends StatefulWidget {
  final PasscodeController controller;
  final List<FocusNode> focusNodes;
  final List<TextEditingController> textControllers;
  final VoidCallback onCompleted;

  const PasscodePadWidget({
    Key? key,
    required this.controller,
    required this.focusNodes,
    required this.textControllers,
    required this.onCompleted,
  }) : super(key: key);

  @override
  _PasscodePadWidgetState createState() => _PasscodePadWidgetState();
}

class _PasscodePadWidgetState extends State<PasscodePadWidget> {
  @override
  void dispose() {
    for (var focusNode in widget.focusNodes) {
      focusNode.dispose();
    }
    for (var textController in widget.textControllers) {
      textController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) => _buildPasscodeField(index)),
        ),
        SizedBox(height: 20),
        _buildNumpad(),
      ],
    );
  }

  Widget _buildPasscodeField(int index) {
    return Container(
      width: 55,
      child: TextField(
        controller: widget.textControllers[index],
        focusNode: widget.focusNodes[index],
        readOnly: true,
        obscureText: true,
        style: TextStyle(fontSize: 16, color: Colors.black),
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 55, vertical: 0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 35,
          crossAxisSpacing: 35,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: index == 11 ? Colors.transparent : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildNumpadButton(index),
          );
        },
      ),
    );
  }

  Widget _buildNumpadButton(int index) {
    if (index == 9) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          setState(() {
            for (var i = 0; i < widget.textControllers.length; i++) {
              widget.textControllers[i].clear();
              widget.controller.updatePasscode('', i);
              FocusScope.of(context).requestFocus(widget.focusNodes[0]);
            }
          });
        },
        child: Text(
          'C',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (index == 11) {
      return Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (var i = widget.textControllers.length - 1; i >= 0; i--) {
                if (widget.textControllers[i].text.isNotEmpty) {
                  widget.textControllers[i].clear();
                  widget.controller.updatePasscode('', i);
                  FocusScope.of(context).requestFocus(widget.focusNodes[i]);
                  break;
                }
              }
            });
          },
          child: Icon(Icons.backspace, color: Colors.deepPurpleAccent),
        ),
      );
    } else {
      int number = index == 10 ? 0 : index + 1;
      return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          setState(() {
            for (var i = 0; i < widget.textControllers.length; i++) {
              if (widget.textControllers[i].text.isEmpty) {
                widget.textControllers[i].text = '$number';
                widget.controller.updatePasscode('$number', i);
                if (i < widget.textControllers.length - 1) {
                  FocusScope.of(context).requestFocus(widget.focusNodes[i + 1]);
                } else if (widget.controller.isPasscodeComplete()) {
                  widget.onCompleted();
                }
                break;
              }
            }
          });
        },
      );
    }
  }
}
