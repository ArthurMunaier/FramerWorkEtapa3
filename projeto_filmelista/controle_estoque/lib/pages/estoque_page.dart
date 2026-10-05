import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/produto.dart';
import '../providers/produto_provider.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProdutoProvider>().carregarProdutos();
    });
  }

  Future<void> excluirProduto(Produto produto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text(
            'Deseja excluir o produto ${produto.nome}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('CANCELAR'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('EXCLUIR'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await context.read<ProdutoProvider>().excluir(
            produto,
          );
    }
  }

  Future<void> diminuirQuantidade(Produto produto) async {
    if (produto.quantidade <= 0) {
      return;
    }

    await context.read<ProdutoProvider>().alterarQuantidade(
          produto,
          produto.quantidade - 1,
        );
  }

  Future<void> aumentarQuantidade(Produto produto) async {
    await context.read<ProdutoProvider>().alterarQuantidade(
          produto,
          produto.quantidade + 1,
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProdutoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ESTOQUE'),
        actions: [
          IconButton(
            onPressed: () {
              provider.carregarProdutos();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: provider.carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.produtos.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum produto cadastrado.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.produtos.length,
                  itemBuilder: (context, index) {
                    final produto = provider.produtos[index];

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    produto.nome,
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),

                                if (produto.quantidade <= 3)
                                  const Chip(
                                    label: Text(
                                      'ESTOQUE BAIXO',
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Categoria: ${produto.categoria}',
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'Preço: R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                            ),

                            const SizedBox(height: 15),

                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    diminuirQuantidade(
                                      produto,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                  ),
                                ),

                                Text(
                                  'Quantidade: ${produto.quantidade}',
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    aumentarQuantidade(
                                      produto,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                ),

                                const Spacer(),

                                TextButton(
                                  onPressed: () {
                                    excluirProduto(
                                      produto,
                                    );
                                  },
                                  child: const Text(
                                    'EXCLUIR',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}