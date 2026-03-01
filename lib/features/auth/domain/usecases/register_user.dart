import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/i_usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class RegisterUser implements IUseCase<UserEntity, UserEntity> {
  final IAuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<IFailure, UserEntity>> call(UserEntity params) async {
    if (params.email.isEmpty || !params.email.contains("@") || params.senha.length < 6) {
      return Left(ValidationFailure("Preencha os campos corretamente!"));
    }
    return await repository.cadastrarUsuario(params);
  }
}
