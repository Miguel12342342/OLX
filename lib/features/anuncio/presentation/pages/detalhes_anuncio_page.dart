import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// NOTE: Theme imports
import '../../../../core/utils/theme_data.dart';
import '../../domain/entities/anuncio_entity.dart';

class DetalhesAnuncioPage extends StatefulWidget {
  final AnuncioEntity anuncio;
  const DetalhesAnuncioPage({super.key, required this.anuncio});

  @override
  State<DetalhesAnuncioPage> createState() => _DetalhesAnuncioPageState();
}

class _DetalhesAnuncioPageState extends State<DetalhesAnuncioPage> {
  AnuncioEntity get _anuncio => widget.anuncio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anúncio")),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: _anuncio.fotos.isNotEmpty ? CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: _anuncio.fotos.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: InteractiveViewer(
                            child: Image.network(url, fit: BoxFit.cover),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ) : Container(color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "R\$ ${_anuncio.preco}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: TemaCustomizado.temaPadrao.primaryColor,
                      ),
                    ),
                    Text(
                      _anuncio.titulo ?? "",
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    const Text(
                      "Descrição",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _anuncio.descricao ?? "",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    const Text(
                      "Contato",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 66),
                      child: Text(
                        _anuncio.telefone ?? "",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: TemaCustomizado.temaPadrao.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Ligar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              onTap: () {
                // Here we would call url_launcher to dial the phone
              },
            ),
          )
        ],
      ),
    );
  }
}
