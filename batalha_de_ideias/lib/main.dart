import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batalha de Ideias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  CollectionReference<Map<String, dynamic>> get colecao =>
      FirebaseFirestore.instance.collection('ideias');

  Future<void> votar(String id) async {
    await colecao.doc(id).update({'votos': FieldValue.increment(1)});
  }

  Future<void> excluir(String id) async {
    await colecao.doc(id).delete();
  }

  Future<void> confirmarExclusao(BuildContext context, String id) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir ideia'),
        content: const Text('Tem certeza que deseja excluir esta ideia?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      await excluir(id);
    }
  }

  void abrirCadastro(BuildContext context) {
    final tituloController = TextEditingController();
    final descricaoController = TextEditingController();
    final autorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova ideia'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              TextField(
                controller: autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final titulo = tituloController.text.trim();
              final descricao = descricaoController.text.trim();
              final autor = autorController.text.trim();

              if (titulo.isEmpty || descricao.isEmpty || autor.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preencha todos os campos!')),
                );
                return;
              }

              await colecao.add({
                'titulo': titulo,
                'descricao': descricao,
                'autor': autor,
                'votos': 0,
              });

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚔️ Batalha de Ideias'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirCadastro(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova ideia'),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: colecao.orderBy('votos', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final ideias = snapshot.data!.docs;

          if (ideias.isEmpty) {
            return const Center(child: Text('Nenhuma ideia cadastrada ainda.'));
          }

          final maisVotada = ideias.first.data();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              // Ranking
              Card(
                color: Colors.amber[100],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        '🏆 IDEIA MAIS VOTADA',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        maisVotada['titulo'],
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text('${maisVotada['votos']} votos'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              for (final doc in ideias)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '💡 ${doc.data()['titulo']}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  confirmarExclusao(context, doc.id),
                            ),
                          ],
                        ),
                        Text('Autor: ${doc.data()['autor']}'),
                        const SizedBox(height: 8),
                        Text(doc.data()['descricao']),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '❤️ ${doc.data()['votos']} votos',
                              style: const TextStyle(fontSize: 16),
                            ),
                            ElevatedButton(
                              onPressed: () => votar(doc.id),
                              child: const Text('VOTAR'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
