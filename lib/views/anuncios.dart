import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/services/anuncio_service.dart';
import 'package:olx/util/Configuracoes.dart';
import 'package:olx/views/widgets/item_anuncio.dart';
import 'package:olx/views/widgets/navegacao.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  final AnuncioService _service = AnuncioService();
  final Navegacao navegacao = Navegacao();

  List<String> itensMenus = [];
  List<DropdownMenuItem<String>> listaItensDropEstados = [];
  List<DropdownMenuItem<String>> listaItensDropCategorias = [];

  String? itemSelecionadoEstado;
  String? itemSelecionadoCategoria;

  void escolhaMenuItem(String itemEscolhido) {
    navegacao.tratarEscolha(context, itemEscolhido);
  }

  Future<void> verificaUsuarioLogado() async {
    setState(() {
      itensMenus = _service.configurarMenu(_service.usuarioAtual);
    });
  }

  void carregarItensDropdown() {
    setState(() {
      listaItensDropCategorias = Configuracoes.getCategorias();
      listaItensDropEstados = Configuracoes.getEstados();
    });
  }

  @override
  void initState() {
    super.initState();
    verificaUsuarioLogado();
    carregarItensDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenus.map((String item) {
                return PopupMenuItem<String>(value: item, child: Text(item));
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltros(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.getAnunciosStream(
                estado: itemSelecionadoEstado,
                categoria: itemSelecionadoCategoria,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError)
                  return const Center(child: Text("Erro ao carregar!"));

                final docs = snapshot.data?.docs ?? [];

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
                    Anuncio anuncio = Anuncio.fromDocumentSnapshot(
                      docs[indice],
                    );
                    return ItemAnuncio(
                      anuncio: anuncio,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    return Row(
      children: [
        _buildDropdown(
          label: "Estado",
          value: itemSelecionadoEstado,
          items: listaItensDropEstados,
          onChanged: (val) => setState(() => itemSelecionadoEstado = val),
        ),
        Container(color: Colors.grey[200], width: 2, height: 60),
        _buildDropdown(
          label: "Categoria",
          value: itemSelecionadoCategoria,
          items: listaItensDropCategorias,
          onChanged: (val) => setState(() => itemSelecionadoCategoria = val),
        ),
      ],
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
          child: DropdownButton(
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
