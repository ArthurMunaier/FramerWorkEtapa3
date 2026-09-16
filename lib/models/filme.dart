class Filme {
  int? id;
  String titulo;
  bool assistido;

  Filme({
    this.id,
    required this.titulo,
    this.assistido = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'assistido': assistido ? 1 : 0,
    };
  }

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      titulo: map['titulo'],
      assistido: map['assistido'] == 1,
    );
  }
}