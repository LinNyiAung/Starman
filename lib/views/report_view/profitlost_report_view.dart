import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/controllers/fusion_controller.dart';
import 'package:starman/models/last_subscription_model/last_subscription_model.dart';
import 'package:starman/models/star_group_model/star_group_model.dart';
import 'package:starman/widgets/navbar_widget.dart';

late SharedPreferences prefs;
StarGroupModel? _starGroupModel;
FusionController fusionController = FusionController();

class ProfitLostReportView extends StatefulWidget {
  const ProfitLostReportView({super.key});

  @override
  State<ProfitLostReportView> createState() => _ProfitLostReportView();
}

// Map of warehouse names to user IDs
final Map<String, String> warehouseToUserIdMap = {
  "DF-Acer": "56B7-1E7F-F68A-4BE8",
  "Asus_black": "5D3A-7D53-1EF7-67A1",
  "DF Asus Small": "BF76-FE5F-6DD0-9FFD",
  "DF Asus HDD": "4CAD-BDAD-478F-4B49",
};



class _ProfitLostReportView extends State<ProfitLostReportView> {
  int? _reamaingDay;
  LastSubscriptionModel? _lastSubscriptionModel;
  String _selectedWarehouse = 'DF-Acer'; // Default warehouse selection
  String _selectedDateFilter = 'Today';



  List<Map<String, dynamic>> starPLData = [];

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
    await _loadPlDataFromFile(); // Load initial data
  }

  Future<void> _loadPlDataFromFile() async {
    try {
      // Load data from the JSON file (assuming the path is known)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/StarPL.json');
      if (file.existsSync()) {
        await _loadPlData(file);
      } else {
        log('StarPL.json file not found');
      }
    } catch (e) {
      log('Error loading data: $e');
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
          title: const Text(
            'အရှုံးအမြတ်အစီရင်ခံစာ',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _downLoadData();
              },
              icon: Icon(
                Icons.cloud_download,
                size: MediaQuery.sizeOf(context).width * 0.07,
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.03,
            ),
          ],
          backgroundColor: Colors.grey[600],
        ),
        body: _starGroupModel == null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              _buildWarehouseDropdown(),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Spacing between dropdowns
                  Expanded(
                    child: _buildDateFilterDropdown(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTotalAmountBox(),
              const SizedBox(height: 10),
              _buildProfitSection(),
              const SizedBox(height: 30),
              _buildLossSection(),
            ],
          ),
        ),
      ),
    );
  }






  Widget _buildProfitSection() {
    // Filter data by selected date filter
    List<Map<String, dynamic>> filteredData = starPLData
        .where((item) => item['starFilter'] == _selectedDateFilter)
        .toList();

    if (filteredData.isEmpty) {
      return const Center(
        child: Text('No data available, download required.', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
      );
    }


    Map<String, dynamic> data = filteredData[0];

    return _buildSectionProfit(
      sectionTitle: '၀င်ငွေ',
      items: [
        _buildDataItem('အရောင်းပမာဏ', data['starSaleAmount']),
        _buildDataItem('ကုန်ပစ္စည်းအရင်းတန်ဖိုး', data['starSoldItemValue']),
        _buildDataItem('အဝယ်လျှော့ဈေး', data['starPurchaseDiscount']),
        _buildDataItem('တခြား၀င်ငွေ', data['starOtherIncome']),
        _buildDataItem('အပိုပေးငွေ', data['starExtraCharge']),
        _buildDataItem('စုစုပေါင်း၀င်ငွေ', data['starTotalIncome']),
      ],
    );
  }

  Widget _buildLossSection() {
    // Filter data by selected date filter
    List<Map<String, dynamic>> filteredData = starPLData
        .where((item) => item['starFilter'] == _selectedDateFilter)
        .toList();

    if (filteredData.isEmpty) {
      return const Center(
        child: Text('No data available, download required.', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
      );
    }

    Map<String, dynamic> data = filteredData[0];

    return _buildSectionLoss(
      sectionTitle: 'ထွက်ငွေ',
      items: [
        _buildDataItem('အရောင်းလျှော့ဈေး', data['starSalesDiscount']),
        _buildDataItem('အရောင်းအခွန်', data['starSalesTax']),
        _buildDataItem('အဝယ်အခွန်', data['starPurchaseTax']),
        _buildDataItem('ကုန်ပစ္စည်းဆုံးရှုံးတန်ဖိုး', data['starDamagedLostAmount']),
        _buildDataItem('တခြားအသုံးစရိတ်', data['starOtherExpense']),
        _buildDataItem('စုစုပေါင်းအသုံးစရိတ်', data['starTotalExpense']),
      ],
    );
  }


  Widget _buildSectionProfit({required String sectionTitle, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 10),
        ...items,
      ],
    );
  }

  Widget _buildSectionLoss({required String sectionTitle, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 10),
        ...items,
      ],
    );
  }

  Widget _buildDataItem(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '$value MMK',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }


  Widget _buildWarehouseDropdown() {
    return Row(
      children: [
        DropdownButton<String>(
          value: _selectedWarehouse,
          onChanged: (String? newValue) {
            setState(() {
              _selectedWarehouse = newValue!;
              // Reset user name filter on warehouse change
            });
          },
          items: warehouseToUserIdMap.keys
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          underline: const SizedBox(), // Removes underline from DropdownButton
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
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


  Widget _buildDateFilterDropdown() {
    return DropdownButton<String>(
      value: _selectedDateFilter,
      onChanged: (String? newValue) {
        setState(() {
          _selectedDateFilter = newValue!;
        });
      },
      items: <String>['Today', 'Yesterday', 'This Month', 'Last Month']
          .map<DropdownMenuItem<String>>((String value) {
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
      underline: const SizedBox(), // Removes underline from DropdownButton
      style: const TextStyle(color: Colors.black, fontSize: 13),
      dropdownColor: Colors.white,
    );
  }






// Method to build the Total Amount Box
  Widget _buildTotalAmountBox() {
    var profitloss;


    // Filter the data according to the selected date filter
    List<Map<String, dynamic>> filteredData = starPLData
        .where((item) => item['starFilter'] == _selectedDateFilter)
        .toList();

    if (filteredData.isNotEmpty) {
      Map<String, dynamic> data = filteredData[0];
      profitloss = data['starProfitLoss'];
    }




    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataItem('အရှုံး/အမြတ်', profitloss),
        ],
      ),
    );
  }

// Helper method to create each row of the total box
  Widget _buildTotalItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }




  //* StarGroup *//
  Future<void> _getStarGroup() async {
    prefs = await SharedPreferences.getInstance(); // Use the global prefs
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
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'Warning!',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
          content: const Text(
            'Your subscription is about to expire. Please renew your subscription.',
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downLoadData() async {
    try {
      // Get the userId based on the selected warehouse
      String userId = warehouseToUserIdMap[_selectedWarehouse] ?? '';

      var file = await fusionController.reportData(
        userId,
        "PL",
      );

      if (file != null) {
        log('Downloaded file path: ${file.path}');
        // Extract the ZIP file
        await extractZipFile(file);
        log("Extraction complete");
      } else {
        log("File download failed");
      }
    } catch (e) {
      log('Error during download: $e');
    }
  }



  Future<void> extractZipFile(File zipFile) async {
    try {
      // Get the application's document directory to extract the files
      final directory = await getApplicationDocumentsDirectory();
      final extractionPath = directory.path;
      log('Extraction path: $extractionPath');

      // Ensure the extraction directory exists
      await Directory(extractionPath).create(recursive: true);

      // Decode the ZIP file with password
      Archive archive = ZipDecoder().decodeBytes(
        zipFile.readAsBytesSync(),
        verify: true,
        password: 'Digital Fusion 2018',
      );

      log('Archive contains ${archive.length} files:');
      for (final file in archive) {
        log('File: ${file.name}, Size: ${file.size}');

        final filename = '$extractionPath/${file.name}';
        if (file.isFile) {
          final outFile = File(filename);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
          await _loadPlData(outFile);
          log('File created: ${outFile.path}');
        } else {
          // If it's a directory, ensure it exists
          await Directory(filename).create(recursive: true);
          log('Directory created: $filename');
        }
      }

      log('ZIP file extracted successfully to $extractionPath');
    } catch (e, stacktrace) {
      log('Error during extraction: $e');
      log('Stacktrace: $stacktrace');
    }
  }

  Future<void> _loadPlData(File file) async {
    try {
      // Read the file
      String jsonData = await file.readAsString();

      // Decode the JSON
      List<dynamic> parsedJson = jsonDecode(jsonData);

      // Assuming each item in the list is a map and filtering by selectedDateFilter
      setState(() {
        starPLData = parsedJson
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList();
      });

      log('Data loaded successfully from ${file.path}');
    } catch (e) {
      log('Error parsing JSON data: $e');
    }
  }
}