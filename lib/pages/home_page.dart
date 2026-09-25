import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/missao.dart';
import '../providers/missao_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tituloController = TextEditingController();
  String dificuldade = 'Fácil';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MissaoProvider>().carregarMissoes();
    });
  }

  @override
  void dispose() {
    tituloController.dispose();
    super.dispose();
  }

  void cadastrar() async {
    if (tituloController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o título da missão.'),
        ),
      );
      return;
    }

    await context.read<MissaoProvider>().adicionarMissao(
          tituloController.text.trim(),
          dificuldade,
        );

    tituloController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missão cadastrada!'),
        ),
      );
    }
  }

  String estrelas(String dificuldade) {
    if (dificuldade == 'Fácil') return '⭐';
    if (dificuldade == 'Médio') return '⭐⭐';
    return '⭐⭐⭐';
  }

  void concluir(Missao missao) async {
    await context.read<MissaoProvider>().concluirMissao(missao);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Missão concluída! Você conquistou ${missao.pontos} pontos.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CENTRAL DE MISSÕES'),
        centerTitle: true,
      ),
      body: Consumer<MissaoProvider>(
        builder: (context, provider, child) {
          if (provider.carregando && provider.missoes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título da missão',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: dificuldade,
                        decoration: const InputDecoration(
                          labelText: 'Dificuldade',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Fácil',
                            child: Text('Fácil - 10 pontos'),
                          ),
                          DropdownMenuItem(
                            value: 'Médio',
                            child: Text('Médio - 20 pontos'),
                          ),
                          DropdownMenuItem(
                            value: 'Difícil',
                            child: Text('Difícil - 30 pontos'),
                          ),
                        ],
                        onChanged: (valor) {
                          setState(() {
                            dificuldade = valor!;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cadastrar,
                          child: const Text('CADASTRAR MISSÃO'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PONTOS CONQUISTADOS: ${provider.pontosTotais}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: provider.missoes.isEmpty
                    ? const Center(
                        child: Text('Nenhuma missão cadastrada.'),
                      )
                    : ListView.builder(
                        itemCount: provider.missoes.length,
                        itemBuilder: (context, index) {
                          final missao = provider.missoes[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    missao.titulo,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Dificuldade: ${estrelas(missao.dificuldade)}',
                                  ),
                                  Text('Pontos: ${missao.pontos}'),
                                  Text(
                                    'Status: ${missao.concluida ? 'Concluída' : 'Pendente'}',
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      if (!missao.concluida)
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => concluir(missao),
                                            child: const Text('CONCLUIR'),
                                          ),
                                        ),
                                      if (!missao.concluida)
                                        const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            context
                                                .read<MissaoProvider>()
                                                .excluirMissao(missao.id!);
                                          },
                                          child: const Text('EXCLUIR'),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
