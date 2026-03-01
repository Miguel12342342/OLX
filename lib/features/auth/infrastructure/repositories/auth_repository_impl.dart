import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<IFailure, UserEntity>> logarUsuario(String email, String senha) async {
    try {
      final userModel = await remoteDataSource.logarUsuario(email, senha);
      return Right(userModel);
    } on IFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, UserEntity>> cadastrarUsuario(UserEntity user) async {
    try {
      final userModel = UserModel(
        nome: user.nome,
        email: user.email,
        senha: user.senha,
        urlImagem: user.urlImagem,
      );
      final resultModel = await remoteDataSource.cadastrarUsuario(userModel);
      return Right(resultModel);
    } on IFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, void>> deslogar() async {
    try {
      final result = await remoteDataSource.deslogar();
      return Right(result);
    } on IFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  UserEntity? get usuarioAtual {
    return remoteDataSource.usuarioAtual;
  }
}
