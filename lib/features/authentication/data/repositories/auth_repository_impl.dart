import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/network/auth_source.dart';
import '../models/login_response.dart';
import '../models/signup_response.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthSource _authSource;

  final SharedPreferences _sharedPreferences;

  AuthRepositoryImpl(this._authSource, this._sharedPreferences,);

  @override
  Future<Either<Failure, LoginResponse>> login(String email, String password,) async {
    final networkResponse = await _authSource.login(email, password);
    if (networkResponse.status == 408) {
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        final response = LoginResponse.fromJson(jsonDecode(networkResponse.data));
        if (response.user != null) {
          await _sharedPreferences.setString("fcm_token", "${response.user?.firebaseConsoleManagerToken}");
          print(_sharedPreferences.getString("fcm_token"));
          await _sharedPreferences.setString("user_id", "${response.user?.id}");
          print(_sharedPreferences.getString("user_id"));
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
  Future<Either<Failure, SignUpResponse>> signup(String fName, String lName, String email, String address, String password,) async {
    final networkResponse = await _authSource.signup(fName, lName, email, address, password,
      _sharedPreferences.getString("fcm_token") ?? "",
    );
    if (networkResponse.status == 408) {
      print(networkResponse.message);
      return Left(Failure(networkResponse.message ?? ""));
    }
    if (networkResponse.data != null) {
      try {
        final response = SignUpResponse.fromJson(jsonDecode(networkResponse.data));
        if (response.id != null) {
          return Right(response);
        } else {
          print(networkResponse.message);
          return Left(Failure(networkResponse.message ?? ""));
        }
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