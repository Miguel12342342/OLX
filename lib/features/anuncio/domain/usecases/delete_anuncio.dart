import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/i_usecase.dart';
import '../repositories/i_anuncio_repository.dart';

class DeleteAnuncioParams {
  final String idAnuncio;
  final String idUsuario;

  DeleteAnuncioParams({required this.idAnuncio, required this.idUsuario});
}

class DeleteAnuncio implements IUseCase<void, DeleteAnuncioParams> {
  final IAnuncioRepository repository;

  DeleteAnuncio(this.repository);

  @override
  Future<Either<IFailure, void>> call(DeleteAnuncioParams params) async {
    return await repository.removerAnuncio(params.idAnuncio, params.idUsuario);
  }
}
