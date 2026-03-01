import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/anuncio_model.dart';
import '../../../../core/errors/failures.dart';

abstract class IAnuncioRemoteDataSource {
  Stream<List<AnuncioModel>> getAnunciosStream({String? estado, String? categoria});
  Stream<List<AnuncioModel>> getMeusAnunciosStream(String idUsuario);
  String gerarId();
  Future<void> salvarAnuncio(AnuncioModel anuncio, String idUsuario);
  Future<void> removerAnuncio(String idAnuncio, String idUsuario);
}

class AnuncioRemoteDataSourceImpl implements IAnuncioRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Stream<List<AnuncioModel>> getAnunciosStream({String? estado, String? categoria}) {
    Query query = _db.collection("anuncios");

    if (estado != null && estado.isNotEmpty) {
      query = query.where("estado", isEqualTo: estado);
    }
    
    if (categoria != null && categoria.isNotEmpty) {
      query = query.where("categoria", isEqualTo: categoria);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AnuncioModel.fromDocumentSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<AnuncioModel>> getMeusAnunciosStream(String idUsuario) {
    return _db
        .collection("meus_anuncios")
        .doc(idUsuario)
        .collection("anuncios")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => AnuncioModel.fromDocumentSnapshot(doc)).toList();
        });
  }

  @override
  String gerarId() {
    return _db.collection("meus_anuncios").doc().id;
  }

  @override
  Future<void> salvarAnuncio(AnuncioModel anuncio, String idUsuario) async {
    try {
      await _db
          .collection("meus_anuncios")
          .doc(idUsuario)
          .collection("anuncios")
          .doc(anuncio.id)
          .set(anuncio.toMap());

      await _db
          .collection("anuncios")
          .doc(anuncio.id)
          .set(anuncio.toMap());
    } catch (e) {
      throw ServerFailure("Erro ao salvar anúncio no Firestore");
    }
  }

  @override
  Future<void> removerAnuncio(String idAnuncio, String idUsuario) async {
    try {
      await _db
          .collection("meus_anuncios")
          .doc(idUsuario)
          .collection("anuncios")
          .doc(idAnuncio)
          .delete();

      await _db.collection("anuncios").doc(idAnuncio).delete();
    } catch (e) {
      throw ServerFailure("Erro ao remover anúncio do Firestore");
    }
  }
}
