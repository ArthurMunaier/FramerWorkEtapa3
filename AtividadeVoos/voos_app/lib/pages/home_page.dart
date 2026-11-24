import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/voo_provider.dart';
import 'detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controlador = TextEditingController(
    text: 'SBGR',
  );

  @override
  void initState() {
    super.initState();

    // carrega os voos assim que a tela abre
    Future.microtask(() {
      context.read<VooProvider>().buscarVoos();
    });
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VooProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PARTE 4: busca por aeroporto (ICAO)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controlador,
                    maxLength: 4,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Aeroporto (ICAO)',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<VooProvider>().buscarVoos(
                          aeroporto: controlador.text,
                        );
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // PARTE 5: tipo de voo
            Wrap(
              spacing: 10,
              children: ['chegadas', 'partidas', 'todos'].map((opcao) {
                return ChoiceChip(
                  label: Text(opcao),
                  selected: provider.tipo == opcao,
                  onSelected: (_) {
                    context.read<VooProvider>().buscarVoos(
                          aeroporto: controlador.text,
                          tipo: opcao,
                        );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            // carregando / erro / lista
            if (provider.carregando)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (provider.erro != null)
              Expanded(
                child: Center(
                  child: Text(
                    provider.erro!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (provider.voos.isEmpty)
              const Expanded(
                child: Center(child: Text('Nenhum voo encontrado')),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.voos.length,
                  itemBuilder: (context, index) {
                    final voo = provider.voos[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.flight),
                        title: Text('${voo['identificacao']}'),
                        subtitle: Text(
                          '${voo['local'] ?? '-'}\n${voo['categoria']}',
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetalhesPage(voo: voo);
                              },
                            ),
                          );
                        },
                      ),
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
