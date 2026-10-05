class Produto {
  final int? id;
  final String nome;
  final String categoria;
  final int quantidade;
  final double preco;

  Produto({this.id, required this.nome, required this.categoria, required this.quantidade, required this.preco});
  Map<String, dynamic> toMap() => {'id': id, 'nome': nome, 'categoria': categoria, 'quantidade': quantidade, 'preco': preco};
  factory Produto.fromMap(Map<String, dynamic> map) => Produto(id: map['id'], nome: map['nome'], categoria: map['categoria'], quantidade: map['quantidade'], preco: (map['preco'] as num).toDouble());
}
