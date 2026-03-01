import 'package:flutter/material.dart';
import '../../domain/entities/anuncio_entity.dart';
import '../controllers/meus_anuncios_controller.dart';
import '../widgets/item_anuncio.dart';

import '../../infrastructure/datasources/anuncio_remote_datasource.dart';
import '../../infrastructure/repositories/anuncio_repository_impl.dart';
import '../../domain/usecases/get_meus_anuncios_stream.dart';
import '../../domain/usecases/delete_anuncio.dart';

import '../../../auth/infrastructure/datasources/auth_remote_datasource.dart';
import '../../../auth/infrastructure/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/get_current_user.dart';

class MeusAnunciosPage extends StatefulWidget {
  const MeusAnunciosPage({super.key});

  @override
  State<MeusAnunciosPage> createState() => _MeusAnunciosPageState();
}

class _MeusAnunciosPageState extends State<MeusAnunciosPage> {
  late final MeusAnunciosController _controller;

  @override
  void initState() {
    super.initState();
    // DIY Dependency Injection
    final authRemoteDS = AuthRemoteDataSourceImpl();
    final authRepo = AuthRepositoryImpl(authRemoteDS);
    final anuncioRemoteDS = AnuncioRemoteDataSourceImpl();
    final anuncioRepo = AnuncioRepositoryImpl(anuncioRemoteDS);

    _controller = MeusAnunciosController(
      getMeusAnunciosStream: GetMeusAnunciosStream(anuncioRepo),
      deleteAnuncio: DeleteAnuncio(anuncioRepo),
      getCurrentUser: GetCurrentUser(authRepo),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmarExclusao(String idAnuncio) {
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
            onPressed: () {
              Navigator.pop(context);
              _controller.removerAnuncio(idAnuncio);
            },
            child: const Text("Remover", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
        icon: const Icon(Icons.add),
        label: const Text("Adicionar"),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.streamAnuncios == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<List<AnuncioEntity>>(
            stream: _controller.streamAnuncios,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Erro ao carregar dados!"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Nenhum anúncio encontrado."));
              }

              final anuncios = snapshot.data!;

              return ListView.builder(
                itemCount: anuncios.length,
                itemBuilder: (_, indice) {
                  final anuncio = anuncios[indice];

                  return ItemAnuncio(
                    // Update ItemAnuncio to accept AnuncioEntity instead of AnuncioModel later
                    anuncio: anuncio,
                    onPressedRemover: () => _confirmarExclusao(anuncio.id!),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
