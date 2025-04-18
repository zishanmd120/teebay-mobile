import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teebay_mobile/core/network/success.dart';
import 'package:teebay_mobile/features/product/data/datasources/network/product_datasource.dart';
import 'package:teebay_mobile/features/product/data/models/categories_model.dart';
import 'package:teebay_mobile/features/product/data/models/products_response.dart';

import '../../../../core/network/failure.dart';
import '../../domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {

  final ProductDatasource productDatasource;
  final SharedPreferences _sharedPreferences;
  ProductRepositoryImpl(this.productDatasource, this._sharedPreferences,);

  @override
  Future<Either<Failure, List<ProductsResponse>>> getProducts() async {
    final networkResponse = await productDatasource.getProducts();
    if (networkResponse.status == 408) {
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        final List<dynamic> data = jsonDecode(networkResponse.data);
        List<ProductsResponse> response = data
            .map((item) => ProductsResponse.fromJson(item))
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
  Future<Either<Failure, Success>> addProduct(String title, String description,
      String purchasePrice, String rentPrice,
      String rentOption, List<String> categories, String productImage,) async {
    final networkResponse = await productDatasource.addProduct(
      _sharedPreferences.getString("user_id") ?? "",
      title, description, purchasePrice, rentPrice, rentOption, categories, productImage,
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
  Future<Either<Failure, ProductsResponse>> getProductDetails(int productId) async {
    final networkResponse = await productDatasource.getSingleProduct(productId);
    if (networkResponse.status == 408) {
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        var data = jsonDecode(networkResponse.data);
        var response = ProductsResponse.fromJson(data);
        if (response.id != null) {
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
  Future<Either<Failure, List<CategoriesResponse>>> getCategories() async {
    final networkResponse = await productDatasource.getCategories();
    if (networkResponse.status == 408) {
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        final List<dynamic> data = jsonDecode(networkResponse.data);
        List<CategoriesResponse> response = data
            .map((item) => CategoriesResponse.fromJson(item))
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
  Future<Either<Failure, Success>> updateProduct(int productId, String title, String description, String purchasePrice, String rentPrice, String rentOption, List<String> categories) async {
    final networkResponse = await productDatasource.updateProduct(
      productId,
      _sharedPreferences.getString("user_id") ?? "",
      title, description, purchasePrice, rentPrice, rentOption, categories,
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
  Future<Either<Failure, Success>> deleteProduct(int productId) async {
    final networkResponse = await productDatasource.deleteProducts(
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

}