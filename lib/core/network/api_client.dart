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
      ).timeout(const Duration(seconds: 10,),);

      _logger.logUrl(endpoint);
      _logger.debugLog(response);

      if (response.statusCode == 200) {
        return NetworkResponse.withSuccess(utf8.decode(response.bodyBytes), "success", response.statusCode);
      } else {
        return NetworkResponse.withFailure("error", response.statusCode);
      }
    } on TimeoutException {
      _logger.errorLog("TimeoutException");
      return NetworkResponse.withFailure("Unable to connect the server.", 408);
    } catch (error){
      _logger.errorLog(error.toString());
      return NetworkResponse.withFailure(error.toString(), 503);
    }
  }

  Future<NetworkResponse<dynamic>> post({
    required String endpoint,
    String token = "",
    Map<String, dynamic> ? body,
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
      ).timeout(const Duration(seconds: 10,),);

      print(response.statusCode);
      print(response.body);
      _logger.logUrl(endpoint);
      _logger.debugLog(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
        return NetworkResponse.withSuccess(utf8.decode(response.bodyBytes), decodedBody['message'], response.statusCode);
      } else {
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
        final errors = decodedBody['error'];
        String firstError = '';
        if (errors is Map) {
          for (var field in errors.entries) {
            if (field.value is List && field.value.isNotEmpty) {
              firstError = field.value.first;
              break;
            }
          }
        }
        return NetworkResponse.withFailure(firstError.isNotEmpty ? firstError : errors, response.statusCode);
      }
    } on TimeoutException {
      _logger.errorLog("TimeoutException");
      return NetworkResponse.withFailure("Unable to connect the server.", 408);
    } catch (error){
      _logger.errorLog(error.toString());
      return NetworkResponse.withFailure(error.toString(), null);
    }
  }

  Future<NetworkResponse<dynamic>> delete({
    required String endpoint,
    String token = "",
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(endpoint),
      ).timeout(const Duration(seconds: 10,),);

      _logger.logUrl(endpoint);
      _logger.debugLog(response);

      if (response.statusCode == 204) {
        return NetworkResponse.withSuccess(utf8.decode(response.bodyBytes), "success", response.statusCode);
      } else {
        return NetworkResponse.withFailure("error", response.statusCode);
      }
    } on TimeoutException {
      _logger.errorLog("TimeoutException");
      return NetworkResponse.withFailure("Unable to connect the server.", 408);
    } catch (error){
      _logger.errorLog(error.toString());
      return NetworkResponse.withFailure(error.toString(), 503);
    }
  }

  Future<NetworkResponse<dynamic>> postMultipart({
    required String endpoint,
    String token = "",
    required http.MultipartRequest request
  }) async {
    try {
      var headers = {
        'accept': 'application/json',
      };

      request.headers.addAll(headers);

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      print(response.statusCode);
      print(respStr);

      _logger.logUrl(endpoint);

      if (response.statusCode == 201) {
        final decodedBody = jsonDecode(respStr);
        return NetworkResponse.withSuccess(
          respStr,
          decodedBody['message'] ?? "Success",
          response.statusCode,
        );
      } else {
        final decodedBody = jsonDecode(respStr);
        final errors = decodedBody['error'];
        String firstError = '';

        if (errors is Map) {
          for (var field in errors.entries) {
            if (field.value is List && field.value.isNotEmpty) {
              firstError = field.value.first;
              break;
            }
          }
        }

        return NetworkResponse.withFailure(
          firstError.isNotEmpty ? firstError : errors.toString(),
          response.statusCode,
        );
      }
    } catch (error){
      _logger.errorLog(error.toString());
      return NetworkResponse.withFailure(error.toString(), null);
    }
  }

}