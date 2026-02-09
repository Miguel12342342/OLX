import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  String? id;
  String? estado;
  String? categoria;
  String? titulo;
  String? preco;
  String? telefone;
  String? descricao;
  List<String>? fotos;

  Anuncio({
    this.id,
    this.estado,
    this.categoria,
    this.titulo,
    this.preco,
    this.telefone,
    this.descricao,
    this.fotos,
  });

  Anuncio.gerarId() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    id = anuncios.doc().id;
    fotos = []; 
  }

  factory Anuncio.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Anuncio(
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