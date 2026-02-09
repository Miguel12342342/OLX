import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {
  final Anuncio anuncio;
  const DetalhesAnuncio({super.key, required this.anuncio});

  @override
  State<DetalhesAnuncio> createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  late Anuncio _anuncio;

  int currentIndex = 0;

  Future<void> ligarTelefone(String? telefone) async {
  if (telefone != null) {
    final Uri url = Uri.parse("tel:$telefone");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } 
  }
}

  @override
  void initState() {
    super.initState();
    _anuncio = widget.anuncio;
  }

  List<Widget> getListaImagens() {
    if (_anuncio.fotos == null || _anuncio.fotos!.isEmpty) {
      return [const Center(child: Text("Sem imagens"))];
    }

    return _anuncio.fotos!.map((url) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      );
    }).toList();
  }

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
                child: CarouselSlider(
                  items: getListaImagens(),
                  options: CarouselOptions(
                    height: 250,
                    enlargeCenterPage: true,
                    autoPlay: (_anuncio.fotos?.length ?? 0) > 1,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _anuncio.fotos!.asMap().entries.map((item) {
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == item.key
                          ? Colors.purple
                          : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "R\$ ${_anuncio.preco}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      _anuncio.titulo!,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Descrição",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _anuncio.descricao!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Contato",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(bottom: 66),
                      child: Text(
                        _anuncio.telefone!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: GestureDetector(           
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Ligar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),),               
                )
                ),
              onTap: () {
                ligarTelefone(_anuncio.telefone);
              },
            ),
          ),
        ],
      ),
    );
  }
}
