import '../entities/anuncio_entity.dart';
import '../repositories/i_anuncio_repository.dart';

class GetAnunciosStream {
  final IAnuncioRepository repository;

  GetAnunciosStream(this.repository);

  Stream<List<AnuncioEntity>> call({String? estado, String? categoria}) {
    return repository.getAnunciosStream(estado: estado, categoria: categoria);
  }
}
