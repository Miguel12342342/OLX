import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/anuncio_entity.dart';

abstract class IAnuncioRepository {
  Stream<List<AnuncioEntity>> getAnunciosStream({String? estado, String? categoria});
  Stream<List<AnuncioEntity>> getMeusAnunciosStream(String idUsuario);
  String gerarId();
  Future<Either<IFailure, void>> salvarAnuncio(AnuncioEntity anuncio, String idUsuario);
  Future<Either<IFailure, void>> removerAnuncio(String idAnuncio, String idUsuario);
}
