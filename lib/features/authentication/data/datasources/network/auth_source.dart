import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_response.dart';
import '../../../../../core/utils/endpoints.dart';

class AuthSource {

  final NetworkHttpClient _httpClient;

  AuthSource(this._httpClient,);

  Future<NetworkResponse<dynamic>> login(String email, String password,) async {
    return await _httpClient.post(
      endpoint: Endpoints.login,
      body: {
        "email": email,
        "password": password,
      },
    );
  }

  Future<NetworkResponse<dynamic>> signup(String fName, String lName, String email, String address, String password, String token,) async {
    return await _httpClient.post(
      endpoint: Endpoints.signup,
      body: {
        "first_name": fName,
        "last_name": lName,
        "email": email,
        "address": address,
        "password": password,
        "firebase_console_manager_token": token,
      },
    );
  }


}