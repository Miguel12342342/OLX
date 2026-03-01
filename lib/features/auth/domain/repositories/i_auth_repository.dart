import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<Either<IFailure, UserEntity>> logarUsuario(String email, String senha);
  Future<Either<IFailure, UserEntity>> cadastrarUsuario(UserEntity user);
  Future<Either<IFailure, void>> deslogar();
  UserEntity? get usuarioAtual;
}
