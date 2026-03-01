import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.nome = "",
    required super.email,
    required super.senha,
    super.urlImagem = "",
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      nome: map["nome"] ?? "",
      email: map["email"] ?? "",
      senha: "", // Não retornamos a senha do BD
      urlImagem: map["urlImagem"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "email": email,
      "urlImagem": urlImagem,
      // Não salvamos a senha no map pro firestore
    };
  }
}
