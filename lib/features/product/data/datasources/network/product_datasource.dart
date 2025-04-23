import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_response.dart';
import '../../../../../core/utils/endpoints.dart';
import 'package:http/http.dart' as http;

class ProductDatasource {

  final NetworkHttpClient _httpClient;
  ProductDatasource(this._httpClient,);

  Future<NetworkResponse<dynamic>> addProduct(String sellerId, String title,
      String description, String purchasePrice, String rentPrice,
      String rentOption, List<String> categories, String productImage,) async {

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.products)
    );

    request.fields.addAll({
      "seller": sellerId,
      "title": title,
      "description": description,
      "purchase_price": purchasePrice,
      "rent_price": rentPrice,
      "rent_option": rentOption,
    });

    for (var category in categories) {
      request.files.add(
        http.MultipartFile.fromString('categories', category),
      );
    }

    if(productImage != ""){
      request.files.add(await http.MultipartFile.fromPath(
        'product_image',
        productImage,
      ));
    }

    return await _httpClient.postMultipart(
      endpoint: Endpoints.products,
      request: request,
    );
  }


  Future<NetworkResponse<dynamic>> updateProduct(int productId, String sellerId, String title,
      String description, String purchasePrice, String rentPrice,
      String rentOption, List<String> categories,) async {

    var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${Endpoints.products}$productId/")
    );

    request.fields.addAll({
      "seller": sellerId,
      "title": title,
      "description": description,
      "purchase_price": purchasePrice,
      "rent_price": rentPrice,
      "rent_option": rentOption,
    });

    for (var category in categories) {
      request.files.add(
        http.MultipartFile.fromString('categories', category),
      );
    }

    return await _httpClient.postMultipart(
      endpoint: Endpoints.products,
      request: request,
    );
  }

  Future<NetworkResponse<dynamic>> getProducts() async {
    return await _httpClient.get(
      endpoint: Endpoints.products,
    );
  }

  Future<NetworkResponse<dynamic>> getSingleProduct(int productId) async {
    return await _httpClient.get(
      endpoint: "${Endpoints.products}$productId/",
    );
  }

  Future<NetworkResponse<dynamic>> getCategories() async {
    return await _httpClient.get(
      endpoint: Endpoints.categories,
    );
  }

  Future<NetworkResponse<dynamic>> deleteProducts(int productId) async {
    return await _httpClient.delete(
      endpoint: "${Endpoints.products}$productId/",
    );
  }

}