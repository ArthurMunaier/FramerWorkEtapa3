import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pedido_viewmodel.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final clienteController = TextEditingController();
  final pratoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      context.read<PedidoViewModel>().carregarPedidos();
    });
  }

  void cadastrarPedido() async {
    await context.read<PedidoViewModel>().adicionarPedido(
      clienteController.text,
      pratoController.text,
      int.parse(quantidadeController.text),
      double.parse(valorController.text),
    );

    clienteController.clear();
    pratoController.clear();
    quantidadeController.clear();
    valorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos - The Bear'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: clienteController,
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                  ),
                ),
                TextField(
                  controller: pratoController,
                  decoration: const InputDecoration(
                    labelText: 'Prato',
                  ),
                ),
                TextField(
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                  ),
                ),
                TextField(
                  controller: valorController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valor Unitário',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: cadastrarPedido,
                  child: const Text('Cadastrar Pedido'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<PedidoViewModel>(
              builder: (context, viewModel, child) {
                return ListView.builder(
                  itemCount: viewModel.pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = viewModel.pedidos[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pedido.cliente} | ${pedido.prato}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Quantidade: ${pedido.quantidade}'),
                            Text(
                              'Total: R\$ ${pedido.total.toStringAsFixed(2).replaceAll('.', ',')}',
                            ),
                            Text(
                              'Classificação: ${pedido.classificacao}',
                            ),
                            Text('Status: ${pedido.status}'),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: pedido.status == 'Pendente'
                                      ? () {
                                          viewModel.finalizarPedido(
                                            pedido.id!,
                                          );
                                        }
                                      : null,
                                  child: const Text('FINALIZAR'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    viewModel.excluirPedido(
                                      pedido.id!,
                                    );
                                  },
                                  child: const Text('EXCLUIR'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
