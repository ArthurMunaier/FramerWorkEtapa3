import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import 'tela_detalhes_pokemon.dart';

class TelaPokemon extends StatefulWidget {
  const TelaPokemon({
    super.key,
  });

  @override
  State<TelaPokemon> createState() {
    return _TelaPokemonState();
  }
}

class _TelaPokemonState extends State<TelaPokemon> {
  final TextEditingController controlador = TextEditingController();

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  // Executa a busca (pesquisa ou aleatório) e abre a tela de detalhes
  Future<void> abrirDetalhes(Future<bool> Function() busca) async {
    final encontrou = await busca();

    if (!mounted) return;

    if (encontrou) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const TelaDetalhesPokemon();
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pokémon não encontrado'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokédex',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PARTE 1: pesquisa por nome
            TextField(
              controller: controlador,
              decoration: const InputDecoration(
                labelText: 'Nome do Pokémon',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      abrirDetalhes(
                        () => context
                            .read<PokemonProvider>()
                            .pesquisarPorNome(controlador.text),
                      );
                    },
                    child: const Text('Pesquisar'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // PARTE 3: pokémon aleatório
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      abrirDetalhes(
                        () => context.read<PokemonProvider>().carregarAleatorio(),
                      );
                    },
                    child: const Text('Pokémon Aleatório'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PokemonProvider>().carregarPokemons();
              },
              child: const Text(
                'Buscar Pokémon',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (provider.carregando) const CircularProgressIndicator(),
            if (!provider.carregando)
              Expanded(
                child: ListView.builder(
                  itemCount: provider.pokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = provider.pokemons[index];

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          pokemon['imagem'],
                          width: 60,
                        ),
                        title: Text(
                          pokemon['nome'].toString().toUpperCase(),
                        ),
                        subtitle: Text(
                          'Tipo: ${pokemon['tipo']}',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TelaDetalhesPokemon(
                                  idPokemon: pokemon['id'],
                                );
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
