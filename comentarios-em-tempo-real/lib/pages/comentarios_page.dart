import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/comentario_service.dart';

class ComentariosPage extends StatefulWidget {
  final String publicacaoId;
  const ComentariosPage({super.key, required this.publicacaoId});

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final texto = TextEditingController();
  final service = ComentarioService();
  bool enviando = false;

  @override
  void dispose() {
    texto.dispose();
    super.dispose();
  }

  Future<void> enviar() async {
    if (texto.text.trim().isEmpty) return;
    setState(() => enviando = true);
    try {
      await service.comentar(widget.publicacaoId, texto.text);
      texto.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao comentar: $e')));
      }
    } finally {
      if (mounted) setState(() => enviando = false);
    }
  }

  Future<void> excluir(String id) async {
    try {
      await service.excluir(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Não foi possível excluir: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final meuUid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Discussão')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: service.acompanharPublicacao(widget.publicacaoId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Erro ao carregar publicação: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final post = snapshot.data!.data();
                if (post == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Esta publicação não existe mais.'),
                  );
                }
                return Card(
                  margin: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(post['autorNome'] ?? 'Usuário'),
                    subtitle: Text(post['texto'] ?? ''),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Comentários',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const Divider(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: service.acompanharComentarios(widget.publicacaoId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Erro ao carregar comentários: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final comentarios = snapshot.data!.docs.toList();
                  comentarios.sort((a, b) {
                    final ta = a.data()['data'] as Timestamp?;
                    final tb = b.data()['data'] as Timestamp?;
                    final va = ta?.millisecondsSinceEpoch ?? 1 << 62;
                    final vb = tb?.millisecondsSinceEpoch ?? 1 << 62;
                    return va.compareTo(vb);
                  });
                  if (comentarios.isEmpty) {
                    return const Center(
                        child: Text('Nenhum comentário ainda. Comece a conversa!'));
                  }
                  return ListView.builder(
                    itemCount: comentarios.length,
                    itemBuilder: (context, index) {
                      final doc = comentarios[index];
                      final c = doc.data();
                      final meu = c['autorId'] == meuUid;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: const CircleAvatar(
                              child: Icon(Icons.person_outline)),
                          title: Text(c['autorNome'] ?? 'Usuário'),
                          subtitle: Text(c['texto'] ?? ''),
                          // Só o dono do comentário vê o botão de excluir.
                          trailing: meu
                              ? IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: 'Excluir comentário',
                                  onPressed: () => excluir(doc.id),
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: texto,
                      maxLength: 280,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => enviando ? null : enviar(),
                      decoration: const InputDecoration(
                        labelText: 'Escreva um comentário',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Enviar',
                    onPressed: enviando ? null : enviar,
                    icon: const Icon(Icons.send),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
