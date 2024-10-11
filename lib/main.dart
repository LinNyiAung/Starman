import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starman/models/exp_model/exp_model.dart';
import 'package:starman/views/error_view.dart';
import 'package:starman/views/existing_passcode_view.dart';
import 'package:get/route_manager.dart';
import 'package:starman/views/home_view.dart';
import 'package:starman/views/new_error_view.dart';
import 'package:starman/views/report_view/cf_daily_report_view.dart';
import 'package:starman/views/report_view/cf_report_view.dart';
import 'package:starman/views/report_view/exp_report_view.dart';
import 'package:starman/views/report_view/np_report_view.dart';
import 'package:starman/views/report_view/ns_report_view.dart';
import 'package:starman/views/report_view/oc_report_view.dart';
import 'package:starman/views/report_view/os_report_view.dart';
import 'package:starman/views/report_view/pi_report_view.dart';
import 'package:starman/views/report_view/profitlost_report_view.dart';
import 'package:starman/views/report_view/rs_report_view.dart';
import 'package:starman/views/report_view/sb_report_view.dart';
import 'package:starman/views/report_view/si_report_view.dart';
import 'package:starman/views/report_view/sp_report_view.dart';
import 'package:starman/views/starid_view.dart';
import 'package:starman/views/passcode_view.dart';
import 'package:starman/views/splashscreen.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFA39FD9);
  static const Color secondaryColor = Color(0xFFA6A6A6);
}

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/starId', page: () => StaridView()),
    GetPage(name: '/passcode', page: () => PasscodeView()),
    GetPage(name: '/home', page: () => HomeView()),
    GetPage(name: '/error', page: () => ErrorView()),
    GetPage(name: '/existingPasscode', page: () => ExistingPasscodeView()),
    GetPage(name: '/profitlost', page: () => ProfitLostReportView()),
    GetPage(name: '/cfreport', page: () => CfReportView()),
    GetPage(name: '/expreport', page: () => EXPReportView()),
    GetPage(name: '/nsreport', page: () => NsReportView()),
    GetPage(name: '/cfdreport', page: () => CfDailyReportView()),
    GetPage(name: '/sireport', page: () => SiReportView()),
    GetPage(name: '/npreport', page: () => NpReportView()),
    GetPage(name: '/pireport', page: () => PiReportView()),
    GetPage(name: '/rsreport', page: () => RsReportView()),
    GetPage(name: '/sbreport', page: () => SbReportView()),
    GetPage(name: '/osreport', page: () => OsReportView()),
    GetPage(name: '/ocreport', page: () => OcReportView()),
    GetPage(name: '/spreport', page: () => SpReportView()),
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

    return GetMaterialApp(
      getPages: routes,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
