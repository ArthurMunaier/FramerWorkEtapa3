import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/produto.dart';
import '../providers/produto_provider.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() =>
      _CadastroProdutoPageState();
}

class _CadastroProdutoPageState
    extends State<CadastroProdutoPage> {
  final nomeController = TextEditingController();
  final categoriaController = TextEditingController();
  final quantidadeController = TextEditingController();
  final precoController = TextEditingController();

  Future<void> cadastrarProduto() async {
    final nome = nomeController.text.trim();
    final categoria = categoriaController.text.trim();

    final quantidade = int.tryParse(
      quantidadeController.text,
    );

    final preco = double.tryParse(
      precoController.text.replaceAll(',', '.'),
    );

    if (nome.isEmpty ||
        categoria.isEmpty ||
        quantidade == null ||
        preco == null ||
        quantidade < 0 ||
        preco < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha todos os campos corretamente.',
          ),
        ),
      );

      return;
    }

    final produto = Produto(
      nome: nome,
      categoria: categoria,
      quantidade: quantidade,
      preco: preco,
    );

    await context.read<ProdutoProvider>().cadastrar(
          produto,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produto cadastrado com sucesso!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'NOVO PRODUTO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: categoriaController,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: quantidadeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Preço',
                      prefixText: 'R\$ ',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cadastrarProduto,
                      child: const Text(
                        'CADASTRAR PRODUTO',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}