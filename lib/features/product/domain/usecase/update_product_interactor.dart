import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/success.dart';
import '../repository/product_repository.dart';

class UpdateProductInteractor {

  final ProductRepository productRepository;
  UpdateProductInteractor(this.productRepository);

  Future<Either<Failure, Success>> execute(int productId, String title, String description,
      String purchasePrice, String rentPrice,
      String rentOption, List<String> categories,) async {
    return await productRepository.updateProduct(productId, title, description, purchasePrice, rentPrice, rentOption, categories,);
  }

}