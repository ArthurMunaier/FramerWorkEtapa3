import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../services/banco_service.dart';

class PedidoViewModel extends ChangeNotifier {
  final BancoService banco = BancoService();

  List<Pedido> pedidos = [];

  Future<void> carregarPedidos() async {
    pedidos = await banco.buscarPedidos();
    notifyListeners();
  }

  Future<void> adicionarPedido(
    String cliente,
    String prato,
    int quantidade,
    double valorUnitario,
  ) async {
    double total = quantidade * valorUnitario;

    Pedido pedido = Pedido(
      cliente: cliente,
      prato: prato,
      quantidade: quantidade,
      valorUnitario: valorUnitario,
      total: total,
      status: 'Pendente',
    );

    await banco.inserirPedido(pedido);
    await carregarPedidos();
  }

  Future<void> finalizarPedido(int id) async {
    await banco.finalizarPedido(id);
    await carregarPedidos();
  }

  Future<void> excluirPedido(int id) async {
    await banco.excluirPedido(id);
    await carregarPedidos();
  }
}
