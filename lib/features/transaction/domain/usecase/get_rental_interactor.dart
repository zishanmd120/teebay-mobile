import 'package:dartz/dartz.dart';
import 'package:teebay_mobile/features/transaction/data/models/rental_list_model.dart';
import 'package:teebay_mobile/features/transaction/domain/repository/transaction_repositories.dart';

import '../../../../core/network/failure.dart';

class GetRentalInteractor {

  final TransactionRepositories transactionRepositories;
  GetRentalInteractor(this.transactionRepositories);

  Future<Either<Failure, List<RentalResponse>>> execute() async {
    return await transactionRepositories.getRentalList();
  }

}