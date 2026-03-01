import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/i_usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class LoginUserParams {
  final String email;
  final String senha;

  LoginUserParams({required this.email, required this.senha});
}

class LoginUser implements IUseCase<UserEntity, LoginUserParams> {
  final IAuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<IFailure, UserEntity>> call(LoginUserParams params) async {
    if (params.email.isEmpty || !params.email.contains("@") || params.senha.length < 6) {
      return Left(ValidationFailure("Preencha os campos corretamente!"));
    }
    return await repository.logarUsuario(params.email, params.senha);
  }
}
