import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/anuncios.dart';
import 'package:olx/views/detalhes_anuncio.dart';
import 'package:olx/views/login.dart';
import 'package:olx/views/meus_anuncios.dart';
import 'package:olx/views/novo_anuncio.dart';

class RouteGenerator {

static Route<dynamic> generateRoute(RouteSettings settings){

 // final args = settings.arguments;

switch(settings.name){
  case"/":
  return MaterialPageRoute(
    builder: (context)=> Anuncios()
    );
    case"/login":
  return MaterialPageRoute(
    builder: (context)=> Login()
    );
     case"/meus-anúncios":
  return MaterialPageRoute(
    builder: (context)=> MeusAnuncios()
    );
     case"/novo-anuncio":
  return MaterialPageRoute(
    builder: (context)=> NovoAnuncio()
    );
    case"/detalhes-anuncio":
  return MaterialPageRoute(
    builder: (context)=> DetalhesAnuncio(anuncio:settings.arguments as Anuncio  )
    );
    default:
      return _errorRota();
    
}
}

static Route<dynamic> _errorRota(){
  return MaterialPageRoute(builder: (context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela não encontrada!"),
      ),
      body: Center(
        child: Text("Tela não encontrada!"),
      ),
    );
  });
}

}