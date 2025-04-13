import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'logger.dart';
import 'network_response.dart';


class NetworkHttpClient {

  final HttpLogger _logger;

  NetworkHttpClient(this._logger,);

  Future<NetworkResponse<dynamic>> get({
    required String endpoint,
    String token = "",
  }) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
      ).timeout(const Duration(seconds: 5,),);

      _logger.logUrl(endpoint);
      _logger.debugLog(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse.withSuccess(utf8.decode(response.bodyBytes), "success", response.statusCode);
      } else {
        return NetworkResponse.withFailure("error", response.statusCode);
      }
    } on TimeoutException {
      _logger.errorLog("TimeoutException");
      // Something went wrong.
      // Unable to connect the server.
      return NetworkResponse.withFailure("Unable to connect the server.", 408);
    } catch (error){
      _logger.errorLog(error.toString());
      return NetworkResponse.withFailure(error.toString(), 503);
    }
  }

  Future<NetworkResponse<dynamic>> post({
    required String endpoint,
    String token = "",
    required Map<String, dynamic> body,
  }) async {
    try {
      print(endpoint);
      print(body);
      final response = await http.post(
        Uri.parse(endpoint),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 5,),);

      print(response.statusCode);
      print(response.body);
      _logger.logUrl(endpoint);
      _logger.debugLog(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse.withSuccess(utf8.decode(response.bodyBytes), "success", response.statusCode);
      } else {
        return NetworkResponse.withFailure("error", response.statusCode);
      }
    } on TimeoutException {
      _logger.errorLog("TimeoutException");
      return NetworkResponse.withFailure("Unable to connect the server.", 408);
    } catch (error){
      _logger.errorLog(error.toString());
      return NetworkResponse.withFailure(error.toString(), null);
    }
  }

}