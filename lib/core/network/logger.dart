import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

// abstract class HttpLogger {
//
//   void debugLog(http.Response response);
//
//   void logUrl(String message);
//
//   void errorLog(String message);
// }

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
