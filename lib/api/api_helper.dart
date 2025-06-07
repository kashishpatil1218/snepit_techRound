import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiHelper{

  Future<Map> fetchData() async {
    String api = "https://dummyjson.com/products";
    Uri uri = Uri.parse(api);

    Response response = await http.get(uri);

    if(response.statusCode==200)
      {
        final json = response.body;
        final Map data = jsonDecode(json);

        return data;
      }
    else{
      return {};
    }
  }
}