// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:archive/archive.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:starman/controllers/fusion_controller.dart';
// import 'package:starman/models/last_subscription_model/last_subscription_model.dart';
// import 'package:starman/models/star_group_model/star_group_model.dart';
// import 'package:starman/widgets/navbar_widget.dart';
//
// late SharedPreferences prefs;
// StarGroupModel? _starGroupModel;
// FusionController fusionController = FusionController();
//
// class NsReportView extends StatefulWidget {
//   const NsReportView({super.key});
//
//   @override
//   State<NsReportView> createState() => _NsReportView();
// }
//
// // Map of warehouse names to user IDs
// final Map<String, String> warehouseToUserIdMap = {
//   "DF-Acer": "56B7-1E7F-F68A-4BE8",
//   "Asus_black": "5D3A-7D53-1EF7-67A1",
//   "DF Asus Small": "BF76-FE5F-6DD0-9FFD",
//   "DF Asus HDD": "4CAD-BDAD-478F-4B49",
// };
//
// class _NsReportView extends State<NsReportView> {
//   int? _reamaingDay;
//   LastSubscriptionModel? _lastSubscriptionModel;
//   String _selectedWarehouse = 'DF-Acer'; // Default warehouse selection
//   String _selectedDateFilter = 'Today'; // Default date filter selection
//   String? _selectedUserName; // Default user name filter selection
//   List<String> _userNames = []; // List of unique usernames
//   int? _selectedStarStatus;
//
//   List<Map<String, dynamic>> starNSData = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _initializeData();
//   }
//
//   Future<void> _initializeData() async {
//     await _getStarGroup();
//     await _getLastSubscription();
//     _reamaingDay = await _remainingDate();
//     if (_reamaingDay! < 10) {
//       _remainingBox();
//     }
//     await _loadExpDataFromFile(); // Load initial data
//   }
//
//   Future<void> _loadExpDataFromFile() async {
//     try {
//       // Load data from the JSON file (assuming the path is known)
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/StarEXP.json');
//       if (file.existsSync()) {
//         await _loadExpData(file);
//       } else {
//         log('StarEXP.json file not found');
//       }
//     } catch (e) {
//       log('Error loading data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         drawer: _starGroupModel == null
//             ? null
//             : NavBar(
//           starId: _starGroupModel!.starId.toString(),
//           reaminingDate: _reamaingDay.toString(),
//         ),
//         appBar: AppBar(
//           title: const Text(
//             'NS Report',
//             style: TextStyle(fontSize: 18),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 await _downLoadData();
//               },
//               icon: Icon(
//                 Icons.cloud_download,
//                 size: MediaQuery.sizeOf(context).width * 0.07,
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.sizeOf(context).width * 0.03,
//             ),
//           ],
//           backgroundColor: Colors.grey[600],
//         ),
//         body: _starGroupModel == null
//             ? const Center(
//           child: CircularProgressIndicator(),
//         )
//             : Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: ListView(
//             children: [
//               _buildWarehouseDropdown(),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildDateFilterDropdown(),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: _buildUserNameFilterDropdown(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _buildTotalAmountBox(),
//               const SizedBox(height: 10),
//               _buildNetSaleList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNetSaleList() {
//     // Filter the data according to the selected date filter and username
//     List<Map<String, dynamic>> filteredData = starNSData
//         .where((item) =>
//     item['starFiler'] == _selectedDateFilter &&
//         (_selectedUserName == null ||
//             item['starNSItemList'].any((nsItem) =>
//             nsItem['starUserName'] == _selectedUserName)))
//         .toList();
//
//     if (filteredData.isEmpty) {
//       return const Center(
//         child: Text(
//           'No data available, click the download button.',
//           style: TextStyle(fontSize: 16, color: Colors.redAccent),
//         ),
//       );
//     }
//
//     List<dynamic> starNSItemList = filteredData[0]['starNSItemList'];
//
//     return Column(
//       children: [
//         // Header row with titles
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//           color: Colors.grey[300],
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Expanded(flex: 2, child: Text('Invoice', style: TextStyle(fontWeight: FontWeight.bold))),
//               Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
//               Expanded(flex: 2, child: Text('Paid Amount', style: TextStyle(fontWeight: FontWeight.bold))),
//             ],
//           ),
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: starNSItemList.length,
//           itemBuilder: (context, index) {
//             var item = starNSItemList[index];
//             return Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(flex: 2, child: Text(item['starInvovice'] ?? '')),
//                   Expanded(flex: 2, child: Text('${item['starAmount']} MMK')),
//                   Expanded(flex: 2, child: Text('${item['starPaidAmount']} MMK')),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWarehouseDropdown() {
//     return Row(
//       children: [
//         DropdownButton<String>(
//           value: _selectedWarehouse,
//           onChanged: (String? newValue) {
//             setState(() {
//               _selectedWarehouse = newValue!;
//             });
//           },
//           items: warehouseToUserIdMap.keys
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.black,
//                 ),
//               ),
//             );
//           }).toList(),
//           underline: const SizedBox(), // Removes underline from DropdownButton
//           style: const TextStyle(color: Colors.black, fontSize: 13),
//         ),
//         const Spacer(),
//         Text(
//           DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
//           style: const TextStyle(
//             fontSize: 13,
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDateFilterDropdown() {
//     return DropdownButton<String>(
//       value: _selectedDateFilter,
//       onChanged: (String? newValue) {
//         setState(() {
//           _selectedDateFilter = newValue!;
//         });
//       },
//       items: <String>['Today', 'Yesterday', 'This Month', 'Last Month']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Colors.black,
//             ),
//           ),
//         );
//       }).toList(),
//       underline: const SizedBox(), // Removes underline from DropdownButton
//       style: const TextStyle(color: Colors.black, fontSize: 13),
//       dropdownColor: Colors.white,
//     );
//   }
//
//   Widget _buildUserNameFilterDropdown() {
//     return DropdownButton<String>(
//       value: _selectedUserName,
//       onChanged: (String? newValue) {
//         setState(() {
//           _selectedUserName = newValue;
//         });
//       },
//       items: _userNames.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Colors.black,
//             ),
//           ),
//         );
//       }).toList(),
//       underline: const SizedBox(), // Removes underline from DropdownButton
//       style: const TextStyle(color: Colors.black, fontSize: 13),
//       dropdownColor: Colors.white,
//     );
//   }
//
//   Future<void> _getStarGroup() async {
//     try {
//       _starGroupModel = await fusionController.getStarGroup();
//       setState(() {});
//     } catch (e) {
//       log('Error fetching star group: $e');
//     }
//   }
//
//   Future<void> _getLastSubscription() async {
//     try {
//       _lastSubscriptionModel = await fusionController.getLastSubscription();
//       setState(() {});
//     } catch (e) {
//       log('Error fetching last subscription: $e');
//     }
//   }
//
//   Future<int?> _remainingDate() async {
//     try {
//       final DateTime now = DateTime.now();
//       final DateTime endDate = DateTime(2024, 8, 31); // Replace with your actual end date
//       final int remainingDays = endDate.difference(now).inDays;
//       return remainingDays;
//     } catch (e) {
//       log('Error calculating remaining date: $e');
//       return null;
//     }
//   }
//
//   Future<void> _remainingBox() async {
//     try {
//       log('Remaining days are less than 10');
//       // Add your code here
//     } catch (e) {
//       log('Error in remaining box: $e');
//     }
//   }
//
//   Future<void> _downLoadData() async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/StarEXP.json');
//       if (await file.exists()) {
//         final fileData = await file.readAsString();
//         final jsonData = jsonDecode(fileData);
//         setState(() {
//           starNSData = jsonData;
//           _userNames = _extractUniqueUserNames(starNSData); // Extract usernames
//         });
//       } else {
//         log('StarEXP.json file not found');
//       }
//     } catch (e) {
//       log('Error downloading data: $e');
//     }
//   }
//
//   List<String> _extractUniqueUserNames(List<Map<String, dynamic>> data) {
//     Set<String> userNamesSet = {};
//     for (var item in data) {
//       if (item['starNSItemList'] != null) {
//         for (var nsItem in item['starNSItemList']) {
//           userNamesSet.add(nsItem['starUserName'] ?? '');
//         }
//       }
//     }
//     return userNamesSet.toList()..sort();
//   }
// }
