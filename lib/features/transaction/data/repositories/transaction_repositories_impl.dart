import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teebay_mobile/core/network/success.dart';
import 'package:teebay_mobile/features/transaction/data/datasources/network/transaction_datasource.dart';
import 'package:teebay_mobile/features/transaction/data/models/rental_list_model.dart';
import 'package:teebay_mobile/features/transaction/data/models/transaction_list_model.dart';
import 'package:teebay_mobile/features/transaction/domain/repository/transaction_repositories.dart';

import '../../../../core/network/failure.dart';

class TransactionRepositoriesImpl implements TransactionRepositories {

  final TransactionDatasource transactionDatasource;
  final SharedPreferences _sharedPreferences;
  TransactionRepositoriesImpl(this.transactionDatasource, this._sharedPreferences,);

  @override
  Future<Either<Failure, List<RentalResponse>>> getRentalList() async {
    final networkResponse = await transactionDatasource.getRentalList();
    if (networkResponse.status == 408) {
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        final List<dynamic> data = jsonDecode(networkResponse.data);
        List<RentalResponse> response = data
            .map((item) => RentalResponse.fromJson(item))
            .toList();
        if (response != []) {
          return Right(response);
        } else {
          return Left(Failure(networkResponse.message ?? ""));
        }
      } catch (e) {
        return Left(Failure("Failed to parse response: ${e.toString()}"));
      }
    } else {
      return Left(Failure(networkResponse.message ?? "Unknown error"));
    }
  }

  @override
  Future<Either<Failure, List<TransactionResponse>>> getTransactionList() async {
    final networkResponse = await transactionDatasource.getTransactionList();
    if (networkResponse.status == 408) {
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        final List<dynamic> data = jsonDecode(networkResponse.data);
        List<TransactionResponse> response = data
            .map((item) => TransactionResponse.fromJson(item))
            .toList();
        if (response != []) {
          return Right(response);
        } else {
          return Left(Failure(networkResponse.message ?? ""));
        }
      } catch (e) {
        return Left(Failure("Failed to parse response: ${e.toString()}"));
      }
    } else {
      return Left(Failure(networkResponse.message ?? "Unknown error"));
    }
  }

  @override
  Future<Either<Failure, Success>> buyProduct(int productId) async {
    final networkResponse = await transactionDatasource.buyProduct(
      _sharedPreferences.getString("user_id") ?? "",
      productId,
    );
    if (networkResponse.status == 408) {
      print(networkResponse.message);
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        return const Right(Success("Product Added Successfully."));
      } catch (e) {
        print(networkResponse.message);
        print("Failed to parse response: ${e.toString()}");
        return Left(Failure("Failed to parse response: ${e.toString()}"));
      }
    } else {
      print(networkResponse.message ?? "Unknown error");
      return Left(Failure(networkResponse.message ?? "Unknown error"));
    }
  }

  @override
  Future<Either<Failure, Success>> rentProduct(int productId, String rentOption, String rentPeriodStartDate, rentPeriodEndDate) async {
    final networkResponse = await transactionDatasource.rentProduct(
      _sharedPreferences.getString("user_id") ?? "",
      productId, rentOption, rentPeriodStartDate, rentPeriodEndDate,
    );
    if (networkResponse.status == 408) {
      print(networkResponse.message);
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        return const Right(Success("Product Added Successfully."));
      } catch (e) {
        print(networkResponse.message);
        print("Failed to parse response: ${e.toString()}");
        return Left(Failure("Failed to parse response: ${e.toString()}"));
      }
    } else {
      print(networkResponse.message ?? "Unknown error");
      return Left(Failure(networkResponse.message ?? "Unknown error"));
    }
  }

}