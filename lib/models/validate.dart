import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'network_info.dart';

Future Validate() async {
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  var obtainedAccessToken =
  sharedPreferences.getString('access_token');
  var obtainedRefreshToken =
  sharedPreferences.getString('refresh_token');

  var getinfo = await http.get(currentUserURI, headers: {
    HttpHeaders.authorizationHeader: 'Bearer $obtainedAccessToken'
  }).timeout(Duration(seconds: 10));

  // print(getinfo.body);

  // String username = await jsonDecode(getinfo.body)['dealer_user'];
  // print('Username is $username');

  if (getinfo.statusCode == 200) {
    print('Old access key ${getinfo.statusCode} from VALIDATE()');
    return obtainedAccessToken;
  }

  var contentBody = jsonDecode(getinfo.body);

  var messageIs = contentBody['msg'];
  if (messageIs == 'Token has expired') {
    var refreshInfo = await http.post(refreshTokenURI, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $obtainedRefreshToken'
    });
    if (refreshInfo.statusCode == 200) {
      var new_access_token = refreshInfo.body;
      var accessTokenDecode = jsonDecode(new_access_token);
      var access_token = accessTokenDecode['access_token'];
      print(
          'New access key from refresh code  from VALIDATE() ${refreshInfo.statusCode}');
      sharedPreferences.setString('access_token', access_token);
      return access_token;
    } else {
      return null;
    }
  }
}