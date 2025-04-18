import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_response.dart';
import '../../../../../core/utils/endpoints.dart';

class TransactionDatasource {

  final NetworkHttpClient _httpClient;
  TransactionDatasource(this._httpClient,);

  Future<NetworkResponse<dynamic>> getTransactionList() async {
    return await _httpClient.get(
      endpoint: Endpoints.purchase,
    );
  }

  Future<NetworkResponse<dynamic>> getRentalList() async {
    return await _httpClient.get(
      endpoint: Endpoints.rentals,
    );
  }

  Future<NetworkResponse<dynamic>> buyProduct(String userId, int productId) async {
    return await _httpClient.post(
      endpoint: Endpoints.purchase,
      body: {
        "buyer": userId,
        "product": productId,
      },
    );
  }

  Future<NetworkResponse<dynamic>> rentProduct(String userId, int productId, String rentOption, String rentPeriodStartDate, rentPeriodEndDate,) async {
    return await _httpClient.post(
      endpoint: Endpoints.rentals,
      body: {
        "renter": userId,
        "product": productId,
        "rent_option": rentOption,
        "rent_period_start_date": rentPeriodStartDate,
        "rent_period_end_date": rentPeriodEndDate,
      },
    );
  }

}