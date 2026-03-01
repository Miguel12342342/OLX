import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/i_usecase.dart';
import '../entities/anuncio_entity.dart';
import '../repositories/i_anuncio_repository.dart';

class SaveAnuncioParams {
  final AnuncioEntity anuncio;
  final String idUsuario;

  SaveAnuncioParams({required this.anuncio, required this.idUsuario});
}

class SaveAnuncio implements IUseCase<void, SaveAnuncioParams> {
  final IAnuncioRepository repository;

  SaveAnuncio(this.repository);

  @override
  Future<Either<IFailure, void>> call(SaveAnuncioParams params) async {
    return await repository.salvarAnuncio(params.anuncio, params.idUsuario);
  }
}
