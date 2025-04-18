import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/success.dart';
import '../repository/product_repository.dart';

class AddProductInteractor {

  final ProductRepository productRepository;
  AddProductInteractor(this.productRepository);

  Future<Either<Failure, Success>> execute(String title, String description,
      String purchasePrice, String rentPrice,
      String rentOption, List<String> categories, String productImage,) async {
    return await productRepository.addProduct(title, description, purchasePrice, rentPrice, rentOption, categories, productImage,);
  }

}