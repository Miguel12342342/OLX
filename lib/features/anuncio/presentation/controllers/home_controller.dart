import 'package:flutter/material.dart';
import '../../domain/entities/anuncio_entity.dart';
import '../../domain/usecases/get_anuncios_stream.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../auth/domain/usecases/logout_user.dart';
import '../../../../../util/configuracoes.dart';
import '../../../../../core/usecases/i_usecase.dart';

class HomeController extends ChangeNotifier {
  final GetAnunciosStream getAnunciosStream;
  final GetCurrentUser getCurrentUser;
  final LogoutUser logoutUser;

  List<String> itensMenus = [];
  List<DropdownMenuItem<String>> listaItensDropEstados = [];
  List<DropdownMenuItem<String>> listaItensDropCategorias = [];

  String? itemSelecionadoEstado;
  String? itemSelecionadoCategoria;

  HomeController({
    required this.getAnunciosStream,
    required this.getCurrentUser,
    required this.logoutUser,
  }) {
    _carregarItensDropdown();
    verificaUsuarioLogado();
  }

  void verificaUsuarioLogado() {
    final usuario = getCurrentUser();
    if (usuario == null) {
      itensMenus = ["Entrar / Cadastrar"];
    } else {
      itensMenus = ["Meus anúncios", "Deslogar"];
    }
    notifyListeners();
  }

  void _carregarItensDropdown() {
    listaItensDropCategorias = Configuracoes.getCategorias();
    listaItensDropEstados = Configuracoes.getEstados();
    notifyListeners();
  }

  void setEstado(String? estado) {
    itemSelecionadoEstado = estado;
    notifyListeners();
  }

  void setCategoria(String? categoria) {
    itemSelecionadoCategoria = categoria;
    notifyListeners();
  }

  Future<void> deslogar() async {
    await logoutUser(NoParams());
  }

  Stream<List<AnuncioEntity>> get anunciosStream => getAnunciosStream(
        estado: itemSelecionadoEstado,
        categoria: itemSelecionadoCategoria,
      );
}
