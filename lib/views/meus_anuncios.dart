import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/widgets/item_anuncio.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final controller = StreamController<QuerySnapshot>.broadcast();
  String? idUsuarioLogado;


  Future removerAnuncio(String idAnuncio)async{

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("meus_anuncios")
    .doc(idUsuarioLogado)
    .collection("anuncios")
    .doc(idAnuncio)
    .delete().then((_){
      db.collection("anuncios")
      .doc(idAnuncio)
      .delete();
    })
    ;

    await db.collection("anuncios").doc(idAnuncio).delete();

  }

void confirmarExclusao(String idAnuncio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("Deseja realmente excluir o anúncio?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await removerAnuncio(idAnuncio);
            },
            child: const Text("Remover", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    if (usuarioLogado != null) {
      idUsuarioLogado = usuarioLogado.uid;
      adicionarListenerAnuncios(); 
    }
  }

  void adicionarListenerAnuncios() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(idUsuarioLogado) 
        .collection("anuncios")
        .snapshots();

    stream.listen((dados) {
      if (!controller.isClosed) {
        controller.add(dados);
      }
    });
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Anúncios")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff6a1b9a),
          foregroundColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, "/novo-anuncio"),
          icon: Icon(Icons.add),
          label: Text("Adicionar"),
          ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) return const Text("Erro ao carregar dados!");

              QuerySnapshot querySnapshot = snapshot.data!;
              
              return ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (_, indice) {
                  List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                  DocumentSnapshot item = anuncios[indice];
                  Anuncio anuncio = Anuncio.fromDocumentSnapshot(item);
                  
                  return ItemAnuncio(
                    anuncio: anuncio,
                    onPressedRemover: () { 
                    confirmarExclusao(anuncio.id!);
                     },
                  );
                },
              );
          }
        },
      ),
    );
  }
}