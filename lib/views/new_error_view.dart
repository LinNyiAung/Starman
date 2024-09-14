import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starman/widgets/background_widget.dart';

class NewErrorView extends StatefulWidget {
  const NewErrorView({super.key});

  @override
  State<NewErrorView> createState() => _NewErrorViewState();
}

class _NewErrorViewState extends State<NewErrorView> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Background.getBackground(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                'Star Id',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              // user id

              Text(
                '1460-130F',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 80,
              ),

              Text(
                "Your License has been Expired.\nTo continue to use, Please contact\n09-42766768",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              //user id
              SizedBox(
                height: 180,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
