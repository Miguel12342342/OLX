import '../entities/anuncio_entity.dart';
import '../repositories/i_anuncio_repository.dart';

class GetMeusAnunciosStream {
  final IAnuncioRepository repository;

  GetMeusAnunciosStream(this.repository);

  Stream<List<AnuncioEntity>> call(String idUsuario) {
    return repository.getMeusAnunciosStream(idUsuario);
  }
}
