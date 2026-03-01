import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

// Este caso de uso não é assíncrono e não retorna Either pois é síncrono no Firebase Auth
class GetCurrentUser {
  final IAuthRepository repository;

  GetCurrentUser(this.repository);

  UserEntity? call() {
    return repository.usuarioAtual;
  }
}
