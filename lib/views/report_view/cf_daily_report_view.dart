import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:starman/models/cfd_model/cfd_model.dart';
import 'package:starman/models/last_subscription_model/last_subscription_model.dart';
import 'package:starman/models/star_group_model/star_group_model.dart';
import 'package:starman/models/star_links_model/star_links_model.dart';
import 'package:starman/widgets/navbar_widget.dart';
import '../../controllers/fusion_controller.dart';


late SharedPreferences prefs;
StarGroupModel? _starGroupModel;

class CfDailyReportView extends StatefulWidget {
  const CfDailyReportView({Key? key}) : super(key: key);

  @override
  State<CfDailyReportView> createState() => _CfDailyReportViewState();
}

class _CfDailyReportViewState extends State<CfDailyReportView> {
  final FusionController fusionController = FusionController();
  int? _remainingDay;
  List<String> _warehouse = [];
  LastSubscriptionModel? _lastSubscriptionModel;
  String _selectedWarehouse = "Warso"; // Default warehouse selection
  String _selectedDateFilter = 'Today'; // Default date filter selection
  List<StarLinksModel>? _starLinksModel;
  CfdModel? thisMonthData;
  List<CfdModel>? _cfDList;
  List<CfdModel>? _displayedCfDList;
  bool _showingAllData = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }


  Future<void> _initializeData() async {
    try {
      await _getStarGroup();
      await _getLastSubscription();
      await _getStarLinks();
      await _getWarehouse();
      await _getCfDData();
      _updateDisplayedList();
      _remainingDay = await _remainingDate();
      if (_remainingDay != null && _remainingDay! < 10) {
        _remainingBox();
      }
    } catch (e) {
      log('Error in _initializeData: $e');
    }
  }

  void _updateDisplayedList() {
    setState(() {
      if (_cfDList != null) {
        _displayedCfDList = _showingAllData ? _cfDList : _cfDList!.take(10).toList();
      }
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _showingAllData = true;
    });
    _updateDisplayedList();
    return Future.delayed(Duration(seconds: 1));
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: _starGroupModel == null
            ? null
            : NavBar(
          starId: _starGroupModel!.starId.toString(),
          reaminingDate: _remainingDay.toString(),
        ),
        appBar: AppBar(
          title: Text(
            'နေ့အလိုက်ဝင်ငွေထွက်ငွေအစီရင်ခံစာ',
            style: TextStyle(fontSize: size(0.045)),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _getCfDData();
              },
              icon: Icon(
                Icons.cloud_download,
                size: MediaQuery.of(context).size.width * 0.07,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
          ],
          backgroundColor: Colors.grey[600],
        ),
        body: _starGroupModel == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: [
                _buildWarehouseDropdown(),
                const SizedBox(height: 1.5),
                _totalCashInOut(89400, 0),
                const SizedBox(height: 2),
                _buildTableHeader(),
                _buildTableData(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWarehouseDropdown() {
    _warehouse = _warehouse.toSet().toList();

    if (!_warehouse.contains(_selectedWarehouse) && _warehouse.isNotEmpty) {
      _selectedWarehouse = _warehouse[0];
    }

    return Row(
      children: [
        _warehouse.isNotEmpty
            ? DropdownButton<String>(
          value: _selectedWarehouse,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedWarehouse = newValue;
              });
            }
          },
          items: _warehouse.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          underline: const SizedBox(),
          style: const TextStyle(color: Colors.black, fontSize: 13),
        )
            : const SizedBox.shrink(),
        const Spacer(),
        Text(
          DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double size(double factor) {
    return MediaQuery.of(context).size.width * factor;
  }

  Widget _totalCashInOut(int cashInPrice, int cashOutPrice) {
    return Container(
      color: Colors.grey[300],
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.03),
        child: Row(
          children: [
            Expanded(child: _totalCash("စုစုပေါင်းငွေအဝင်", cashInPrice)),
            Expanded(child: _totalCash("စုစုပေါင်းငွေအထွက်", cashOutPrice)),
          ],
        ),
      ),
    );
  }

  Widget _totalCash(String title, int price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.038,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ),
        Text(
          '$price MMK',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.038,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(child: Text('စဉ်', style: _tableHeaderStyle())),
          Expanded(child: Text('နေ့စွဲ', style: _tableHeaderStyle())),
          Expanded(child: Text('ငွေ(MMK)', style: _tableHeaderStyle())),
          Expanded(child: Text('ထုတ်ငွေ(MMK)', style: _tableHeaderStyle())),
          Expanded(child: Text('ကျန်ငွေ(MMK)', style: _tableHeaderStyle())),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.035,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  Widget _buildTableData() {
    if (_displayedCfDList == null || _displayedCfDList!.isEmpty) {
      return const Center(child: Text('No data available'));
    }
    int rowIndex = 0;

    return Table(
      children: _displayedCfDList!.map((cfdModel) {
        return cfdModel.starCFByDateDetailList.asMap().entries.map((entry) {
          rowIndex++;
          final index = entry.key;
          final detail = entry.value;
          return TableRow(
            children: [
              _buildTableCell(rowIndex.toString()),
              _buildTableCell(detail.starDate),
              _buildTableCell(detail.starIncome.toString()),
              _buildTableCell(detail.starExpense.toString()),
              _buildTableCell(detail.starBalance.toString()),
            ],
          );
        }).toList();
      }).expand((rows) => rows).toList(),
    );
  }


  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
    );
  }

  Future<void> _getStarGroup() async {
    try {
      prefs = await SharedPreferences.getInstance();
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
    } catch (e) {
      log('Error in _getStarGroup: $e');
    }
  }

  Future<void> _getLastSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? lastSubscriptionJson = prefs.getString('_lastSubscription');
      if (lastSubscriptionJson != null) {
        Map<String, dynamic> lastSubscriptionMap = jsonDecode(lastSubscriptionJson);
        LastSubscriptionModel lastSubscription = LastSubscriptionModel.fromJson(lastSubscriptionMap);
        setState(() {
          _lastSubscriptionModel = lastSubscription;
        });
      } else {
        log('No last subscription found in preferences');
      }
    } catch (e) {
      log('Error in _getLastSubscription: $e');
    }
  }

  Future<int?> _remainingDate() async {
    try {
      if (_lastSubscriptionModel?.licenseInfo?.endDate == null) {
        log('End date is null');
        return null;
      }
      String endDateString = _lastSubscriptionModel!.licenseInfo!.endDate!;
      DateTime endDate = DateFormat('dd/MM/yyyy').parse(endDateString);
      DateTime currentDate = DateTime.now();
      int remainingDays = endDate.difference(currentDate).inDays;
      return remainingDays;
    } catch (e) {
      log('Error in _remainingDate: $e');
      return null;
    }
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
              SizedBox(width: 10),
              Text('Day Remaining'),
            ],
          ),
          content: Text('Your subscription is only ${_remainingDay.toString()} days left'),
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

  Future<void> _getCfDData() async {
    try {
      await _downLoadData();
      await _getCfD("This Month");
      await _getStarLinks();

    } catch (e) {
      log('Error in _getCfDData: $e');
    }
  }

  Future<void> _downLoadData() async {
    try {
      var file = await fusionController.reportData("BF76-FE5F-6DD0-9FFD", "CFD");
      if (file != null && await file.exists()) {
        log('Downloaded file exists at: ${file.path}');
        await extractZipFile(file);
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/StarCFByDate.json';
        if (await File(filePath).exists()) {
          String cfdJson = await readJsonFile(filePath);
          await prefs.setString("_satrCFD", cfdJson);
          log("File StarCFByDate.json found and data stored successfully.");
        } else {
          log("File StarCFByDate.json not found after extraction");
        }
      } else {
        log("File download failed or file does not exist.");
      }
    } catch (e) {
      log('Error in _downLoadData: $e');
    }
  }

  Future<void> extractZipFile(File zipFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final extractionPath = directory.path;
      await Directory(extractionPath).create(recursive: true);
      Archive archive = ZipDecoder().decodeBytes(
        zipFile.readAsBytesSync(),
        verify: true,
        password: 'Digital Fusion 2018',
      );
      for (final file in archive) {
        final filename = '$extractionPath/${file.name}';
        if (file.isFile) {
          final outFile = File(filename);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        } else {
          await Directory(filename).create(recursive: true);
        }
      }
    } catch (e) {
      log('Error in extractZipFile: $e');
    }
  }

  Future<void> _getWarehouse() async {
    try {
      if (_starLinksModel != null) {
        setState(() {
          _warehouse = _starLinksModel!
              .map((link) => link.warehouseName ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
        });
      }
    } catch (e) {
      log('Error in _getWarehouse: $e');
    }
  }

  Future<String> readJsonFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      } else {
        throw Exception("File not found at $path");
      }
    } catch (e) {
      log('Error in readJsonFile: $e');
      rethrow;
    }
  }

  Future<void> _getCfD(String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? starCfD = prefs.getString('_satrCFD');
      log("Raw starCfD data: ${starCfD ?? 'null'}");

      if (starCfD == null || starCfD.isEmpty) {
        log("No data or empty data found in SharedPreferences for '_satrCFD'.");
        return;
      }

      var decodedJson = jsonDecode(starCfD);
      log("Decoded JSON type: ${decodedJson.runtimeType}");

      if (decodedJson is! List) {
        log("Decoded JSON is not a List. Actual type: ${decodedJson.runtimeType}");
        return;
      }

      List<CfdModel> cfDData = [];
      for (var item in decodedJson) {
        try {
          cfDData.add(CfdModel.fromJson(item));
        } catch (e) {
          log("Error parsing CfdModel: $e");
        }
      }

      log("Parsed CfdModel list length: ${cfDData.length}");

      setState(() {
        _cfDList = cfDData;
        thisMonthData = cfDData.firstWhere(
              (model) => model.starFilter == date,
          orElse: () => CfdModel(
            starCFByDateDetailList: [],
            starTotalIncome: 0.0,
            starTotalExpense: 0.0,
            starTotalBalance: 0.0,
            starFilter: '',
            starCurrency: '',
          ),
        );
      });

      log("Data for the specified date found: $thisMonthData");
    } catch (e) {
      log('Error in _getCfD: $e');
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
      _starLinksModel = starLinks;
    } else {
      log("No star links found in preferences");
    }
  }
}