import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/network_response.dart';
import '../../data/models/login_response.dart';

abstract class AuthRepository {

  Future<Either<Failure, LoginResponse>> login(String email, String password);

  // Future<NetworkResponse<LoginResponse>> obtainAccessToken();
  //
  // Future<NetworkResponse<CurrentUserFromDependsResponse>> getCurrentUserFromDepends();
  //
  // Future<NetworkResponse<UserDetailsResponse>> getUserDetails(int? userId, int? accountId);

  // Future<NetworkResponse<dynamic>> logOut();
}
