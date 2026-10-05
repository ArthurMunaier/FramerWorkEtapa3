import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/filme_viewmodel.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FilmeViewModel>().carregarFilmes();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void cadastrarFilme() async {
    String titulo = controller.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome do filme!'),
        ),
      );
      return;
    }

    await context.read<FilmeViewModel>().adicionarFilme(titulo);

    controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filme cadastrado com sucesso!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Filmes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Digite o nome do filme',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cadastrarFilme,
                child: const Text('Adicionar'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Consumer<FilmeViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.filmes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum filme cadastrado.',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: viewModel.filmes.length,
                    itemBuilder: (context, index) {
                      final filme = viewModel.filmes[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: filme.assistido,
                            onChanged: (valor) {
                              viewModel.alterarAssistido(filme);
                            },
                          ),
                          title: Text(
                            filme.titulo,
                            style: TextStyle(
                              fontSize: 18,
                              decoration: filme.assistido
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
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
      ),
    );
  }
}