import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/models/last_subscription_model/last_subscription_model.dart';
import 'package:starman/widgets/navbar_widget.dart';
import '../models/star_group_model/star_group_model.dart';

late SharedPreferences prefs;
StarGroupModel? _starGroupModel;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int? _reamaingDay;
  LastSubscriptionModel? _lastSubscriptionModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getStarGroup();
    await _getLastSubscription();
    _reamaingDay = await _remainingDate();
    if (_reamaingDay! < 10) {
      _remainingBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: _starGroupModel == null
            ? null
            : NavBar(
                starId: _starGroupModel!.starId.toString(),
                reaminingDate: _reamaingDay.toString(),
              ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Home Page'),
          backgroundColor: Colors.grey[600],
        ),
        body: _starGroupModel == null
            ? const Center(
                child: CircularProgressIndicator()) // Show a loading indicator
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Home Page',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  //* StarGroup *//
  Future<void> _getStarGroup() async {
    prefs = await SharedPreferences.getInstance(); // Use the global `prefs`
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
      log('No last subscription found in preferences');
    }
  }

  Future<int> _remainingDate() async {
    String endDateString =
        (_lastSubscriptionModel?.licenseInfo?.endDate).toString();
    DateTime endDate = DateFormat('dd/MM/yyyy').parse(endDateString);
    DateTime currentDate = DateTime.now();
    int remainingDays = endDate.difference(currentDate).inDays;
    return remainingDays;
  }

  Future<void> _remainingBox() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 243, 243),
          title: const Row(
            children: [
              Icon(
                Icons.circle_notifications,
                color: Colors.redAccent,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Day Remaining'),
            ],
          ),
          content:
              Text('Your subscribtion is only ${_reamaingDay.toString()} left'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
