import 'package:dartz/dartz.dart';
import 'package:teebay_mobile/features/transaction/domain/repository/transaction_repositories.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/success.dart';

class BuyProductInteractor {

  final TransactionRepositories transactionRepositories;
  BuyProductInteractor(this.transactionRepositories);

  Future<Either<Failure, Success>> execute(int productId,) async {
    return await transactionRepositories.buyProduct(productId,);
  }

}