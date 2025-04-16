import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../data/models/signup_response.dart';
import '../repositories/auth_repository.dart';

class SignupInteractor {

  final AuthRepository authRepository;
  SignupInteractor(this.authRepository);

  Future<Either<Failure, SignUpResponse>> execute(String fName, String lName, String email, String phone, String password,) async {
    return await authRepository.signup(fName, lName, email, phone, password,);
  }

}