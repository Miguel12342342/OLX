class Usuario {
  String? idUsuario; 
  String nome = "";
  String email = "";
  String senha = ""; 
  String urlImagem = "";

  Usuario();

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "email": email,
      "urlImagem": urlImagem,
    };
  }

  // Converte Map para Objeto (para ler do Firestore)
  Usuario.fromMap(Map<String, dynamic> map) {
    nome = map["nome"] ?? "";
    email = map["email"] ?? "";
    urlImagem = map["urlImagem"] ?? "";
  }
}