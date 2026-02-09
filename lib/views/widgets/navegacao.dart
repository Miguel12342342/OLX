import 'package:flutter/material.dart';
import 'package:olx/services/anuncio_service.dart';

class Navegacao {
  final AnuncioService _service = AnuncioService();

  Future<void> tratarEscolha(BuildContext context, String itemEscolhido) async {
    switch (itemEscolhido) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus-anúncios");
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        await _service.deslogar();

        if (!context.mounted) return;

        Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
        break;
    }
  }
}
