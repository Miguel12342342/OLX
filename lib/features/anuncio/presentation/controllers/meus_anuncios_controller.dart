import 'package:flutter/material.dart';
import '../../domain/entities/anuncio_entity.dart';
import '../../domain/usecases/get_meus_anuncios_stream.dart';
import '../../domain/usecases/delete_anuncio.dart';
import '../../../auth/domain/usecases/get_current_user.dart';

class MeusAnunciosController extends ChangeNotifier {
  final GetMeusAnunciosStream getMeusAnunciosStream;
  final DeleteAnuncio deleteAnuncio;
  final GetCurrentUser getCurrentUser;

  Stream<List<AnuncioEntity>>? streamAnuncios;

  MeusAnunciosController({
    required this.getMeusAnunciosStream,
    required this.deleteAnuncio,
    required this.getCurrentUser,
  }) {
    _iniciarStream();
  }

  void _iniciarStream() {
    final usuarioLogado = getCurrentUser();
    if (usuarioLogado != null && usuarioLogado.id != null) {
      streamAnuncios = getMeusAnunciosStream(usuarioLogado.id!);
      notifyListeners();
    }
  }

  Future<void> removerAnuncio(String idAnuncio) async {
    final usuarioLogado = getCurrentUser();
    if (usuarioLogado != null && usuarioLogado.id != null) {
      final params = DeleteAnuncioParams(idAnuncio: idAnuncio, idUsuario: usuarioLogado.id!);
      await deleteAnuncio(params);
      // Stream updates automatically
    }
  }
}
