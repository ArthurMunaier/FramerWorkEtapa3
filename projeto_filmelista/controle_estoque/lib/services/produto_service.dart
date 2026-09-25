import '../models/produto.dart';
import 'database_service.dart';

class ProdutoService {
  Future<void> cadastrar(Produto produto) async {
    final db = await DatabaseService.banco;
    await db.insert('produtos', produto.toMap());
    print('INSERT → Produto cadastrado: ${produto.nome}');
  }

  Future<List<Produto>> listar() async {
    final db = await DatabaseService.banco;
    final r = await db.query('produtos');
    print('SELECT → Produtos encontrados:');
    for (final produto in r) print(produto);
    return r.map(Produto.fromMap).toList();
  }

  Future<void> atualizarQuantidade(Produto produto, int novaQuantidade) async {
    final db = await DatabaseService.banco;
    await db.update('produtos', {'quantidade': novaQuantidade}, where: 'id = ?', whereArgs: [produto.id]);
    print('UPDATE → ${produto.nome}\nQuantidade anterior: ${produto.quantidade}\nNova quantidade: $novaQuantidade');
  }

  Future<void> excluir(Produto produto) async {
    final db = await DatabaseService.banco;
    await db.delete('produtos', where: 'id = ?', whereArgs: [produto.id]);
    print('DELETE → Produto excluído: ${produto.nome}');
  }

  Future<void> mostrarProdutosNoTerminal() async {
    final db = await DatabaseService.banco;
    final produtos = await db.query('produtos');
    print('===== PRODUTOS NO BANCO =====');
    for (final produto in produtos) print(produto);
  }
}
