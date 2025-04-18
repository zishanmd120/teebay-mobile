import 'package:dartz/dartz.dart';
import 'package:teebay_mobile/features/transaction/domain/repository/transaction_repositories.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/success.dart';

class RentProductInteractor {

  final TransactionRepositories transactionRepositories;
  RentProductInteractor(this.transactionRepositories);

  Future<Either<Failure, Success>> execute(int productId, String rentOption, String rentPeriodStartDate, rentPeriodEndDate,) async {
    return await transactionRepositories.rentProduct(productId, rentOption, rentPeriodStartDate, rentPeriodEndDate,);
  }

}