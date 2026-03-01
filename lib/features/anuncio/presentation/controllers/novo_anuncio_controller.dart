import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/anuncio_entity.dart';
import '../../domain/usecases/save_anuncio.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../../../util/configuracoes.dart';
// Note: We'll inject IStorageRepository via usecase later if we strictly follow DDD
// but for now, uploading images can be handled by a usecase. Let's create an UploadImagens usecase implicitly or inject repository.
import '../../domain/repositories/i_storage_repository.dart';
import '../../domain/repositories/i_anuncio_repository.dart';

class NovoAnuncioController extends ChangeNotifier {
  final SaveAnuncio saveAnuncioUseCase;
  final GetCurrentUser getCurrentUser;
  // In a stricter DDD we'd make an UploadImagensUseCase
  final IStorageRepository storageRepository;
  final IAnuncioRepository anuncioRepository;

  AnuncioEntity anuncio = AnuncioEntity();
  List<File> listaImagens = [];
  List<DropdownMenuItem<String>> listaItensDropEstados = [];
  List<DropdownMenuItem<String>> listaItensDropCategorias = [];

  String? itemSelecionadoEstado;
  String? itemSelecionadoCategoria;

  bool isSaving = false;
  String mensagemErro = "";

  NovoAnuncioController({
    required this.saveAnuncioUseCase,
    required this.getCurrentUser,
    required this.storageRepository,
    required this.anuncioRepository,
  }) {
    // We generate the ID right away so we can upload images to that specific folder
    anuncio = anuncio.copyWith(id: anuncioRepository.gerarId());
    _carregarItensDropdown();
  }

  void _carregarItensDropdown() {
    listaItensDropCategorias = Configuracoes.getCategorias();
    listaItensDropEstados = Configuracoes.getEstados();
    notifyListeners();
  }

  void setEstado(String? estado) {
    itemSelecionadoEstado = estado;
    anuncio = anuncio.copyWith(estado: estado);
    notifyListeners();
  }

  void setCategoria(String? categoria) {
    itemSelecionadoCategoria = categoria;
    anuncio = anuncio.copyWith(categoria: categoria);
    notifyListeners();
  }
  
  void setTitulo(String? titulo) {
    anuncio = anuncio.copyWith(titulo: titulo);
  }

  void setPreco(String? preco) {
    anuncio = anuncio.copyWith(preco: preco);
  }

  void setTelefone(String? telefone) {
    anuncio = anuncio.copyWith(telefone: telefone);
  }

  void setDescricao(String? descricao) {
    anuncio = anuncio.copyWith(descricao: descricao);
  }

  Future<void> selecionarImagemGaleria() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagemSelecionada = await picker.pickImage(source: ImageSource.gallery);

    if (imagemSelecionada != null) {
      listaImagens.add(File(imagemSelecionada.path));
      notifyListeners();
    }
  }

  void removerImagem(int index) {
    listaImagens.removeAt(index);
    notifyListeners();
  }

  Future<bool> salvarAnuncio() async {
    final usuarioLogado = getCurrentUser();
    if (usuarioLogado == null || usuarioLogado.id == null) {
      mensagemErro = "Usuário não logado";
      notifyListeners();
      return false;
    }

    isSaving = true;
    mensagemErro = "";
    notifyListeners();

    // 1. Upload Images
    final uploadResult = await storageRepository.uploadImagens(
      idAnuncio: anuncio.id!,
      imagens: listaImagens,
    );

    return uploadResult.fold(
      (failure) {
        isSaving = false;
        mensagemErro = "Erro ao fazer upload das imagens: ${failure.message}";
        notifyListeners();
        return false;
      },
      (urls) async {
        anuncio = anuncio.copyWith(fotos: urls);

        // 2. Save Anuncio
        final saveParams = SaveAnuncioParams(anuncio: anuncio, idUsuario: usuarioLogado.id!);
        final saveResult = await saveAnuncioUseCase(saveParams);

        isSaving = false;
        notifyListeners();

        return saveResult.fold(
          (failure) {
             mensagemErro = "Erro ao salvar anúncio: ${failure.message}";
             return false;
          },
          (_) => true,
        );
      }
    );
  }
}
