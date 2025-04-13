import 'dart:convert';


import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/network/auth_source.dart';
import '../models/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthSource _authSource;

  // final SessionManager _sessionManager;

  AuthRepositoryImpl(this._authSource,
      // this._sessionManager,
      );

  // @override
  // Future<NetworkResponse<LoginResponse>> login(String email, String password,) async {
  //   NetworkResponse<dynamic> networkResponse = await _authSource.login(email, password,);
  //   if (networkResponse.data != null) {
  //     final response = LoginResponse.fromJson(networkResponse.data);
  //     if (response.accessToken != null) {
  //       // logger.d(response.accessToken);
  //       loggerDev(response.accessToken);
  //       // renew access token in session
  //       // _sessionManager.token = response.accessToken;
  //       // _sessionManager.refreshToken = response.refreshToken;
  //       DateTime expireToken = DateTime.now().add(
  //           Duration(seconds: response.expiresIn ?? 0));
  //       DateTime expireRefreshToken = DateTime.now().add(
  //           Duration(seconds: response.refreshExpiresIn ?? 0));
  //       // _sessionManager.expiredIn = DateFormatter.toStringDateTime(expireToken);
  //       // _sessionManager.refreshExpiredIn =
  //       //     DateFormatter.toStringDateTime(expireRefreshToken);
  //       // final currentUserResponse = await getCurrentUserFromDepends();
  //       // _sessionManager.isLoggedIn =
  //       //     currentUserResponse.status == HttpStatus.ok;
  //       return NetworkResponse.withSuccess(
  //           response, "Successfully login", currentUserResponse.status);
  //     } else {
  //       return NetworkResponse.withSuccess(
  //           response, response.errorDescription, networkResponse.status);
  //     }
  //   }
  //   return NetworkResponse.withFailure(
  //       networkResponse.message, networkResponse.status);
  // }

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

  // @override
  // Future<NetworkResponse> logOut() {
  //   // TODO: implement logOut
  //   throw UnimplementedError();
  // }
}