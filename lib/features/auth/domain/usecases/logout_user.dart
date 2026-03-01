import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/i_usecase.dart';
import '../repositories/i_auth_repository.dart';

class LogoutUser implements IUseCase<void, NoParams> {
  final IAuthRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<IFailure, void>> call(NoParams params) async {
    return await repository.deslogar();
  }
}
