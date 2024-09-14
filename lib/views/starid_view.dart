import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/controllers/fusion_controller.dart';
import 'package:starman/models/cf_model/cf_model.dart';
import 'package:starman/models/last_subscription_model/last_subscription_model.dart';
import 'package:starman/models/star_group_model/star_group_model.dart';
import 'package:starman/models/star_links_model/star_links_model.dart';
import 'package:starman/models/star_subscriptions_model/star_subscriptions_model.dart';
import 'package:starman/widgets/custom_textformfield_widget.dart';

late SharedPreferences prefs;

class StaridView extends StatefulWidget {
  const StaridView({super.key});

  @override
  State<StaridView> createState() => _StaridViewState();
}

class _StaridViewState extends State<StaridView> {
  final TextEditingController _controller = TextEditingController();
  final FusionController fusionController = FusionController();
  StarGroupModel? _starGroupModel;
  LastSubscriptionModel? _lastSubscriptionModel;
  String? starId = '';
  bool _isButtonDisabled = false;
  CfModel? _cfModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  _logo(),
                  const Text(
                    'registration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextFieldWidget(
                    label: 'Star Id',
                    icon: Icons.star,
                    controller: _controller,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled
                          ? null
                          : () async {
                              setState(() {
                                _isButtonDisabled = true;
                                starId = _controller.text;
                              });

                              bool isGetData =
                                  await fusionController.starGroup(starId!);
                              if (isGetData) {
                                await _getData();
                              } else {
                                // ignore: use_build_context_synchronously
                                _showAlertDialog(context);
                              }

                              setState(
                                () {
                                  _isButtonDisabled =
                                      false; // Re-enable the button
                                },
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        elevation: 1,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                        'register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.notification_important_rounded,
                color: Colors.redAccent,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "StarId Not Found!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.sizeOf(context).width * 0.048),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please Call Service Center.'),
                Text('Phone - 09890630456'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getData() async {
    try {
      prefs = await SharedPreferences.getInstance();
      await _getStarGroup();

      if (_starGroupModel == null) {
        log("Star group not found");
        return;
      }
      await Future.wait([
        fusionController.lastSubscription(starId!),
        fusionController.starLinks(starId!),
        fusionController.starSubscriptions(starId!),
        prefs.setString("_starId", starId!)
      ]);
      await _getLastSubscription();
      String? passcode = prefs.getString('user_passcode');
      if (passcode != null) {
        Get.offNamed('/existingPasscode');
      } else {
        Get.offAllNamed('/passcode');
      }
    } catch (e) {
      log("An error occurred while getting data: $e");
    }
  }

  Widget _logo() {
    return Center(
      child: Image.asset(
        'assets/logo.png',
        height: 100,
      ),
    );
  }

  //* StarGroup *//
  Future<void> _getStarGroup() async {
    final prefs = await SharedPreferences.getInstance();
    String? starGroupJson = prefs.getString('_starGroup');
    if (starGroupJson != null) {
      Map<String, dynamic> starGroupMap = jsonDecode(starGroupJson);
      StarGroupModel starGroup = StarGroupModel.fromJson(starGroupMap);
      setState(() {
        _starGroupModel = starGroup;
      });
    } else {
      log('No star group found in preferences');
    }
  }

  //* LastSubscription *//
  Future<void> _getLastSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastSubscriptionJson = prefs.getString('_lastSubscription');

    if (lastSubscriptionJson != null) {
      Map<String, dynamic> lastSubscriptionMap =
          jsonDecode(lastSubscriptionJson);
      LastSubscriptionModel lastSubscription =
          LastSubscriptionModel.fromJson(lastSubscriptionMap);
      setState(() {
        _lastSubscriptionModel = lastSubscription;
      });
    } else {
      log('No star group found in preferences');
    }
  }

  //* StarLinks *//
  Future<void> _getStarLinks() async {
    final prefs = await SharedPreferences.getInstance();
    String? starLinksJson = prefs.getString('_starLinks');
    if (starLinksJson != null) {
      var decodedJson = jsonDecode(starLinksJson);
      List<Map<String, dynamic>> starLinksMap =
          List<Map<String, dynamic>>.from(decodedJson);
      List<StarLinksModel> starLinks =
          StarLinksModel.fromJsonList(starLinksMap);
    } else {
      log("No star links found in preferences");
    }
  }

  //* StarSubscriptions *//
  Future<void> _getStarSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    String? starSubscriptionsJson = prefs.getString("_starSubscriptions");
    var decodedJson = jsonDecode(starSubscriptionsJson!);
    if (starSubscriptionsJson != null) {
      List<Map<String, dynamic>> starSubscriptionsMap =
          List<Map<String, dynamic>>.from(decodedJson);
      List<StarSubscriptionsModel> starSubscriptions =
          StarSubscriptionsModel.fromJsonList(starSubscriptionsMap);
    } else {
      // Handle the case where the string is not available
      log('No star group found in preferences');
    }
  }

  Future<void> _getCf() async {
    final prefs = await SharedPreferences.getInstance();
    String? starCf = prefs.getString('_satrCF');
    var decodeJson = jsonDecode(starCf!);
    if (starCf != null) {
      List<Map<String, dynamic>> starCf =
          List<Map<String, dynamic>>.from(decodeJson);
      List<CfModel> cfData = CfModel.fromJsonList(starCf);
    }
  }
}
