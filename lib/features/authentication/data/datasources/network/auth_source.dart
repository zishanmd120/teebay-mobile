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

}