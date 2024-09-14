import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//* Common PostRequestAPI *//
Future<http.Response> _rootPostRequest({
  required String endpoint,
  required Map<String, String> queryParams,
  required String username,
  required String password,
}) async {
  String basicAuth =
      'Basic ${base64.encode(utf8.encode('$username:$password'))}';
  var url = Uri.https('api.fusionmyanmar.com', endpoint, queryParams);
  final response = await http.post(
    url,
    headers: {
      'Authorization': basicAuth,
      'SECRET_ACCESS_TOKEN':
          "\$2a\$10\$wl2BjK4NHQwB6npW2xOWCOyFN/x3s92TKnLdSDFSVnTCuxIDg8mVG",
    },
  );

  if (response.statusCode == 200) {
    return response;
  } else {
    return response;
  }
}

class FusionApi {
  //* SatrGroupAPI *//
  Future<String> getStarGroup(
    String username,
    String password,
    String endpoint,
    Map<String, String> queryParams,
  ) async {
    final response = await _rootPostRequest(
      endpoint: endpoint,
      queryParams: queryParams,
      username: username, // Replace with your actual username
      password: password, // Replace with your actual password
    );
    return response.body;
  }

//* LastSubscriptionAPI *//
  Future<String> getLastSubscription(
    String username,
    String password,
    String endpoint,
    Map<String, String> queryParams,
  ) async {
    final response = await _rootPostRequest(
      endpoint: endpoint,
      queryParams: queryParams,
      username: username,
      password: password,
    );
    return response.body;
  }

  Future<String> getStarLinks(
    String username,
    String password,
    String endpoint,
    Map<String, String> queryParams,
  ) async {
    final response = await _rootPostRequest(
      endpoint: endpoint,
      queryParams: queryParams,
      username: username,
      password: password,
    );
    return response.body;
  }

//* StarSubscriptionsAPI *//
  Future<String> getStarSubscriptions(
    String username,
    String password,
    String endpoint,
    Map<String, String> queryParams,
  ) async {
    final response = await _rootPostRequest(
        endpoint: endpoint,
        queryParams: queryParams,
        username: username,
        password: password);
    return response.body;
  }

  Future<http.Response> getReportData(
      String username,
      String password,
      String endpoint,
      Map<String, String> queryParams,
      ) async {
    final response = await _rootPostRequest(
      endpoint: endpoint,
      queryParams: queryParams,
      username: username,
      password: password,
    );
    return response;
  }


/*

https://api.fusionmyanmar.com/rest/starman/getStarGroup

Method = POST ,Param {starId}

https://api.fusionmyanmar.com/rest/starman/getStarLinks

Method = POST ,Param {starId}

https://api.fusionmyanmar.com/rest/starman/getLastSubscription

Method = POST ,Param {starId}

https://api.fusionmyanmar.com/rest/starman/getStarSubscriptions

Method = POST ,Param {starId}

*/
// class APIDemo {
//   void httpGet() async {
//     String username = 'fusion_dev';
//     String password = 'fusion_dev';
//     String basicAuth =
//         'Basic ${base64.encode(utf8.encode('$username:$password'))}';
//     dev.log(basicAuth);

//     var queryParameters = {'starId': '957a-562D'};
//     var url = Uri.https(
//         'api.fusionmyanmar.com', '/rest/starman/getStarGroup', queryParameters);

//     var response = await http.post(url, headers: <String, String>{
//       'Authorization': basicAuth,
//       'SECRET_ACCESS_TOKEN':
//           "\$2a\$10\$wl2BjK4NHQwB6npW2xOWCOyFN/x3s92TKnLdSDFSVnTCuxIDg8mVG"
//     });
//     dev.log(response.body);
//   }
// }

// For FusionAPI Testing with POSTMAN
/*

SECRET_ACCESS_TOKEN
$2a$10$wl2BjK4NHQwB6npW2xOWCOyFN/x3s92TKnLdSDFSVnTCuxIDg8mVG

Authorization
Basic MjhQS2RmMjY6ODAxNmZlNmIyNTExNzljMTI3OTU3ZTE4ZDM=


https://api.fusionmyanmar.com/rest/starman/getStarGroup?starId=957a-562D

https://api.fusionmyanmar.com/rest/starman/getStarLinks?starId=957a-562D

https://api.fusionmyanmar.com/rest/starman/getLastSubscription?starId=957a-562D

https://api.fusionmyanmar.com/rest/starman/getStarSubscriptions?starId=957a-562D


*/
}
