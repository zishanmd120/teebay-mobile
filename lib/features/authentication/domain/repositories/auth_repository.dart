import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../data/models/login_response.dart';
import '../../data/models/signup_response.dart';

abstract class AuthRepository {

  Future<Either<Failure, LoginResponse>> login(String email, String password);

  Future<Either<Failure, SignUpResponse>> signup(String fName, String lName, String email, String address, String password,);

}
