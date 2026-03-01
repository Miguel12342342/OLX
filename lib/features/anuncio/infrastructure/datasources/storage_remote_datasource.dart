import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/errors/failures.dart';

abstract class IStorageRemoteDataSource {
  Future<List<String>> uploadImagens({required String idAnuncio, required List<File> imagens});
  Future<void> removerImagens(String idAnuncio);
}

class StorageRemoteDataSourceImpl implements IStorageRemoteDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<List<String>> uploadImagens({
    required String idAnuncio,
    required List<File> imagens
  }) async {
    try {
      List<String> urls = [];
      Reference pastaRaiz = _storage.ref();

      for (var imagem in imagens) {
        String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
        Reference arquivo = pastaRaiz
            .child("meus_anuncios")
            .child(idAnuncio)
            .child(nomeImagem);

        UploadTask task = arquivo.putFile(imagem);
        await task.whenComplete(() {});
        String url = await arquivo.getDownloadURL();
        urls.add(url);
      }

      return urls;
    } catch (e) {
      throw ServerFailure("Erro ao fazer upload das imagens");
    }
  }
  
  @override
  Future<void> removerImagens(String idAnuncio) async {
    try {
      Reference pastaRaiz = _storage.ref().child("meus_anuncios").child(idAnuncio);
      ListResult result = await pastaRaiz.listAll();
      for (Reference ref in result.items) {
        await ref.delete();
      }
    } catch (e) {
      // Ignora erro se as imagens ja foram apagadas
    }
  }
}
