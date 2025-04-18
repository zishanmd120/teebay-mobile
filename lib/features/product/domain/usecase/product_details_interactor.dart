import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../data/models/products_response.dart';
import '../repository/product_repository.dart';

class ProductDetailsInteractor {

  final ProductRepository productRepository;
  ProductDetailsInteractor(this.productRepository);

  Future<Either<Failure, ProductsResponse>> execute(int productId) async {
    return await productRepository.getProductDetails(productId);
  }

}