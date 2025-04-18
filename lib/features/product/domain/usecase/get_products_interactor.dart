import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../data/models/products_response.dart';
import '../repository/product_repository.dart';

class GetProductsInteractor {

  final ProductRepository productRepository;
  GetProductsInteractor(this.productRepository);

  Future<Either<Failure, List<ProductsResponse>>> execute() async {
    return await productRepository.getProducts();
  }

}