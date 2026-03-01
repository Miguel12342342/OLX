import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/anuncio_entity.dart';
import '../../domain/repositories/i_anuncio_repository.dart';
import '../datasources/anuncio_remote_datasource.dart';
import '../models/anuncio_model.dart';

class AnuncioRepositoryImpl implements IAnuncioRepository {
  final IAnuncioRemoteDataSource remoteDataSource;

  AnuncioRepositoryImpl(this.remoteDataSource);

  @override
  String gerarId() {
    return remoteDataSource.gerarId();
  }

  @override
  Stream<List<AnuncioEntity>> getAnunciosStream({String? estado, String? categoria}) {
    // Retorna a stream de models convertida como stream de entities implicitamente (polimorfismo)
    return remoteDataSource.getAnunciosStream(estado: estado, categoria: categoria);
  }

  @override
  Stream<List<AnuncioEntity>> getMeusAnunciosStream(String idUsuario) {
    return remoteDataSource.getMeusAnunciosStream(idUsuario);
  }

  @override
  Future<Either<IFailure, void>> removerAnuncio(String idAnuncio, String idUsuario) async {
    try {
      await remoteDataSource.removerAnuncio(idAnuncio, idUsuario);
      return const Right(null);
    } on IFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, void>> salvarAnuncio(AnuncioEntity anuncio, String idUsuario) async {
    try {
      final model = AnuncioModel.fromEntity(anuncio);
      await remoteDataSource.salvarAnuncio(model, idUsuario);
      return const Right(null);
    } on IFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
