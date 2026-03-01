import 'package:flutter/material.dart';
import '../../domain/entities/anuncio_entity.dart';
import '../controllers/home_controller.dart';
import '../widgets/item_anuncio.dart';

import '../../infrastructure/datasources/anuncio_remote_datasource.dart';
import '../../infrastructure/repositories/anuncio_repository_impl.dart';
import '../../domain/usecases/get_anuncios_stream.dart';

import '../../../auth/infrastructure/datasources/auth_remote_datasource.dart';
import '../../../auth/infrastructure/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../../auth/domain/usecases/logout_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    // DIY Dependency Injection
    final authRemoteDS = AuthRemoteDataSourceImpl();
    final authRepo = AuthRepositoryImpl(authRemoteDS);
    final anuncioRemoteDS = AnuncioRemoteDataSourceImpl();
    final anuncioRepo = AnuncioRepositoryImpl(anuncioRemoteDS);

    _controller = HomeController(
      getAnunciosStream: GetAnunciosStream(anuncioRepo),
      getCurrentUser: GetCurrentUser(authRepo),
      logoutUser: LogoutUser(authRepo),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _escolhaMenuItem(String itemEscolhido) async {
    switch (itemEscolhido) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        await _controller.deslogar();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        elevation: 0,
        actions: <Widget>[
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return PopupMenuButton<String>(
                onSelected: (item) {
                  _escolhaMenuItem(item);
                  _controller.verificaUsuarioLogado();
                },
                itemBuilder: (context) {
                  return _controller.itensMenus.map((String item) {
                    return PopupMenuItem<String>(value: item, child: Text(item));
                  }).toList();
                },
              );
            }
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltros(),
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return StreamBuilder<List<AnuncioEntity>>(
                  stream: _controller.anunciosStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Erro ao carregar!"));
                    }

                    final docs = snapshot.data ?? [];

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhum anúncio!",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, indice) {
                        AnuncioEntity anuncio = docs[indice];
                        return ItemAnuncio(
                          anuncio: anuncio, // Adapt item_anuncio to use AnuncioEntity next
                          onTapItem: () {
                            Navigator.pushNamed(
                              context,
                              "/detalhes-anuncio",
                              arguments: anuncio,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Row(
          children: [
            _buildDropdown(
              label: "Estado",
              value: _controller.itemSelecionadoEstado,
              items: _controller.listaItensDropEstados,
              onChanged: _controller.setEstado,
            ),
            Container(color: Colors.grey[200], width: 2, height: 60),
            _buildDropdown(
              label: "Categoria",
              value: _controller.itemSelecionadoCategoria,
              items: _controller.listaItensDropCategorias,
              onChanged: _controller.setCategoria,
            ),
          ],
        );
      }
    );
  }

  Widget _buildDropdown({
    required String label,
    String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Expanded(
      child: DropdownButtonHideUnderline(
        child: Center(
          child: DropdownButton<String>(
            hint: Text(label),
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
