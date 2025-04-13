import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../data/models/login_response.dart';
import '../repositories/auth_repository.dart';

class LoginInteractor {

  final AuthRepository authRepository;
  LoginInteractor(this.authRepository);

  Future<Either<Failure, LoginResponse>> execute(String email, String password) async {
    return await authRepository.login(email, password);
  }

}