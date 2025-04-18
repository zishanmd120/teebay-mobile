import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/success.dart';
import '../../data/models/categories_model.dart';
import '../../data/models/products_response.dart';

abstract class ProductRepository {

  Future<Either<Failure, List<ProductsResponse>>> getProducts();

  Future<Either<Failure, ProductsResponse>> getProductDetails(int productId);

  Future<Either<Failure, Success>> addProduct(String title, String description,
      String purchasePrice, String rentPrice,
      String rentOption, List<String> categories, String productImage,);

  Future<Either<Failure, Success>> updateProduct(int productId, String title, String description,
      String purchasePrice, String rentPrice,
      String rentOption, List<String> categories,);

  Future<Either<Failure, Success>> deleteProduct(int productId,);

  Future<Either<Failure, List<CategoriesResponse>>> getCategories();

}
