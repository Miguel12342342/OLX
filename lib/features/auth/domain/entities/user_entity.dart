class UserEntity {
  final String? id;
  final String nome;
  final String email;
  final String senha; // In a pure domain, we might not store password, but for registration we need it here
  final String urlImagem;

  UserEntity({
    this.id,
    this.nome = "",
    required this.email,
    required this.senha,
    this.urlImagem = "",
  });
}
