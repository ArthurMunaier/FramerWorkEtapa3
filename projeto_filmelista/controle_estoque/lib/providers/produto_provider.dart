import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class ProdutoProvider extends ChangeNotifier {
  final ProdutoService service = ProdutoService();
  List<Produto> produtos = [];
  bool carregando = false;

  Future<void> carregarProdutos() async {
    carregando = true; notifyListeners();
    produtos = await service.listar();
    carregando = false; notifyListeners();
  }

  Future<void> cadastrar(Produto produto) async { await service.cadastrar(produto); await carregarProdutos(); }
  Future<void> alterarQuantidade(Produto produto, int quantidade) async { if (quantidade < 0) return; await service.atualizarQuantidade(produto, quantidade); await carregarProdutos(); }
  Future<void> excluir(Produto produto) async { await service.excluir(produto); await carregarProdutos(); }
}
