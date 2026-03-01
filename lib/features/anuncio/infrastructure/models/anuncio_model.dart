import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/anuncio_entity.dart';

class AnuncioModel extends AnuncioEntity {
  AnuncioModel({
    super.id,
    super.estado,
    super.categoria,
    super.titulo,
    super.preco,
    super.telefone,
    super.descricao,
    super.fotos = const [],
  });

  factory AnuncioModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AnuncioModel(
      id: doc.id,
      estado: data["estado"],
      categoria: data["categoria"],
      titulo: data["titulo"],
      preco: data["preco"],
      telefone: data["telefone"],
      descricao: data["descricao"],
      fotos: List<String>.from(data["fotos"] ?? []),
    );
  }

  factory AnuncioModel.fromEntity(AnuncioEntity entity) {
    return AnuncioModel(
      id: entity.id,
      estado: entity.estado,
      categoria: entity.categoria,
      titulo: entity.titulo,
      preco: entity.preco,
      telefone: entity.telefone,
      descricao: entity.descricao,
      fotos: entity.fotos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "estado": estado,
      "categoria": categoria,
      "titulo": titulo,
      "preco": preco,
      "telefone": telefone,
      "descricao": descricao,
      "fotos": fotos,
    };
  }
}
