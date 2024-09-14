import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starman/widgets/background_widget.dart';

class ErrorView extends StatefulWidget {
  const ErrorView({super.key});

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  @override
  void initState() {
    super.initState();
  }

  void _tryAgain() {
    // for refresh after the user subscription has been renewed
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

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
                child: GestureDetector(
                  onTap: (_tryAgain),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
