import 'package:dartz/dartz.dart';
import 'package:teebay_mobile/features/transaction/data/models/transaction_list_model.dart';
import 'package:teebay_mobile/features/transaction/domain/repository/transaction_repositories.dart';

import '../../../../core/network/failure.dart';

class GetTransactionInteractor {

  final TransactionRepositories transactionRepositories;
  GetTransactionInteractor(this.transactionRepositories);

  Future<Either<Failure, List<TransactionResponse>>> execute() async {
    return await transactionRepositories.getTransactionList();
  }

}