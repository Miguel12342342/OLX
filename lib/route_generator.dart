import 'package:flutter/material.dart';

import 'features/anuncio/domain/entities/anuncio_entity.dart';
import 'features/anuncio/presentation/pages/home_page.dart';
import 'features/anuncio/presentation/pages/detalhes_anuncio_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/anuncio/presentation/pages/meus_anuncios_page.dart';
import 'features/anuncio/presentation/pages/novo_anuncio_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case "/":
        return MaterialPageRoute(builder: (context) => const HomePage());
      case "/login":
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case "/meus-anuncios":
        return MaterialPageRoute(builder: (context) => const MeusAnunciosPage());
      case "/novo-anuncio":
        return MaterialPageRoute(builder: (context) => const NovoAnuncioPage());
      case "/detalhes-anuncio":
        final anuncio = settings.arguments as AnuncioEntity;
        return MaterialPageRoute(builder: (context) => DetalhesAnuncioPage(anuncio: anuncio));
      default:
        return _errorRota();
    }
  }

  static Route<dynamic> _errorRota(){
    return MaterialPageRoute(builder: (context){
      return Scaffold(
        appBar: AppBar(title: const Text("Tela não encontrada!")),
        body: const Center(child: Text("Tela não encontrada!")),
      );
    });
  }
}