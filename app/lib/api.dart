import 'dart:core';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

const String api_key = '1436b3828bfbfcd8a9bdf8b43d0e91c65291a060';

Future<Map> countCoins(String filePath) async {
  try {
    http.Response response = await http.post(
      'http://coincounter.studio/coincounter/',
      headers: {
        'Content-Type': 'image/jpeg',
        'Accept': "*/*",
        'Content-Length': File(filePath).lengthSync().toString(),
        'Connection': 'keep-alive',
        'Authorization': 'Token ${api_key}'
      },
      body: File(filePath).readAsBytesSync(),
    );

    return json.decode(utf8.decode(response.bodyBytes));
  } catch (e) {
    print(e);
  }
}