class AnuncioEntity {
  final String? id;
  final String? estado;
  final String? categoria;
  final String? titulo;
  final String? preco;
  final String? telefone;
  final String? descricao;
  final List<String> fotos;

  AnuncioEntity({
    this.id,
    this.estado,
    this.categoria,
    this.titulo,
    this.preco,
    this.telefone,
    this.descricao,
    this.fotos = const [],
  });

  AnuncioEntity copyWith({
    String? id,
    String? estado,
    String? categoria,
    String? titulo,
    String? preco,
    String? telefone,
    String? descricao,
    List<String>? fotos,
  }) {
    return AnuncioEntity(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      categoria: categoria ?? this.categoria,
      titulo: titulo ?? this.titulo,
      preco: preco ?? this.preco,
      telefone: telefone ?? this.telefone,
      descricao: descricao ?? this.descricao,
      fotos: fotos ?? this.fotos,
    );
  }
}
