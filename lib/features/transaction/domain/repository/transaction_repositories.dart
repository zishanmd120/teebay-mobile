import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/success.dart';
import '../../data/models/rental_list_model.dart';
import '../../data/models/transaction_list_model.dart';

abstract class TransactionRepositories {

  Future<Either<Failure, List<TransactionResponse>>> getTransactionList();

  Future<Either<Failure, List<RentalResponse>>> getRentalList();

  Future<Either<Failure, Success>> buyProduct(int productId,);

  Future<Either<Failure, Success>> rentProduct(int productId, String rentOption, String rentPeriodStartDate, rentPeriodEndDate,);

}
