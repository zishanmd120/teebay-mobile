import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../data/models/categories_model.dart';
import '../repository/product_repository.dart';

class CategoriesInteractor {

  final ProductRepository productRepository;
  CategoriesInteractor(this.productRepository);

  Future<Either<Failure, List<CategoriesResponse>>> execute() async {
    return await productRepository.getCategories();
  }

}