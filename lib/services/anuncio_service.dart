import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnuncioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream que retorna os anúncios com filtros dinâmicos
  Stream<QuerySnapshot> getAnunciosStream({String? estado, String? categoria}) {
    Query query = _db.collection("anuncios");

    if (estado != null && estado.isNotEmpty) {
      query = query.where("estado", isEqualTo: estado);
    }
    
    if (categoria != null && categoria.isNotEmpty) {
      query = query.where("categoria", isEqualTo: categoria);
    }

    return query.snapshots();
  }

   List<String> configurarMenu(User? usuario) {
  if (usuario == null) {
    return ["Entrar / Cadastrar"];
  } else {
    return ["Meus anúncios", "Deslogar"];
  }
}

  // Lógica de Autenticação centralizada
  User? get usuarioAtual => _auth.currentUser;

  Future<void> deslogar() async {
    await _auth.signOut();
  }
}