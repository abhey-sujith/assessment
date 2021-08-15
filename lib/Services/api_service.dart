import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../Models/data_model.dart';

/*
Class : APIService
Description: Used to make a function to get data from api
 */
class APIService {
  Future<DataModel> getData(cursor) async {
    String url = "";

    // From second api request curser should be added to apiURL
    if(cursor!=""){
      url =
          "&cursor=$cursor";
    }

    // Request to apiURL
    final response = await http.get( Uri.parse(Config.apiURL + url));

    // Returning response
    if (response.statusCode == 200) {
      return DataModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }
}