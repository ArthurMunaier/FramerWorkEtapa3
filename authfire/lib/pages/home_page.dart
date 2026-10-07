import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/missao_provider.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController tituloController = TextEditingController();

  final AuthService authService = AuthService();

  int grauSelecionado = 4;

  @override
  void dispose() {
    tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central Jujutsu'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.sair();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dados do usuário
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (usuario?.photoURL != null)
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(usuario!.photoURL!),
                      )
                    else
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.person),
                      ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Bem-vindo,'),
                          Text(
                            usuario?.displayName ?? 'Usuário',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(usuario?.email ?? 'E-mail não disponível'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Cadastro de missão
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da missão',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<int>(
              value: grauSelecionado,
              decoration: const InputDecoration(
                labelText: 'Grau',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('1')),
                DropdownMenuItem(value: 2, child: Text('2')),
                DropdownMenuItem(value: 3, child: Text('3')),
                DropdownMenuItem(value: 4, child: Text('4')),
              ],
              onChanged: (valor) {
                setState(() {
                  grauSelecionado = valor!;
                });
              },
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = context.read<MissaoProvider>();

                  await provider.adicionar(
                    tituloController.text,
                    grauSelecionado,
                  );

                  tituloController.clear();
                },
                child: const Text('Cadastrar missão'),
              ),
            ),

            const SizedBox(height: 20),

            // Lista de missões
            Expanded(
              child: Consumer<MissaoProvider>(
                builder: (context, provider, child) {
                  if (provider.carregando) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.missoes.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma missão cadastrada.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.missoes.length,
                    itemBuilder: (context, index) {
                      final missao = provider.missoes[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: missao.concluida,
                            onChanged: (valor) {
                              provider.alterarStatus(missao);
                            },
                          ),
                          title: Text(
                            missao.titulo,
                            style: TextStyle(
                              decoration: missao.concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text('Grau: ${missao.grau}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.excluir(missao.id);
                            },
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
