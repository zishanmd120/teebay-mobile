class Endpoints {

  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const String signup = '$baseUrl/users/register/';
  static const String login = '$baseUrl/users/login/';

  static const String products = '$baseUrl/products/';
  static const String categories = '$baseUrl/products/categories/';

  static const String purchase = '$baseUrl/transactions/purchases/';
  static const String rentals = '$baseUrl/transactions/rentals/';

}