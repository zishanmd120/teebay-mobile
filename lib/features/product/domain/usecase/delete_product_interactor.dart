import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/success.dart';
import '../repository/product_repository.dart';

class DeleteProductInteractor {

  final ProductRepository productRepository;
  DeleteProductInteractor(this.productRepository);

  Future<Either<Failure, Success>> execute(int productId,) async {
    return await productRepository.deleteProduct(productId,);
  }

}