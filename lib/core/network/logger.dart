import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class HttpLogger {
  void debugLog(http.Response response) {
    print("DEBUG: ${response.statusCode} - ${response.body}");
  }

  void logUrl(String message) {
    print("REQUEST URL: $message");
  }

  void errorLog(String message) {
    print("ERROR: $message");
  }
}


loggerDev(data) => developer.log(data);
