import 'package:flutter/material.dart';

import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  List<dynamic> pokemons = [];

  Map<String, dynamic>? pokemonSelecionado;

  bool carregando = false;

  Future<void> carregarPokemons() async {
    carregando = true;

    notifyListeners();

    pokemons = await PokemonService.buscarPokemons();

    carregando = false;

    notifyListeners();
  }

  Future<void> carregarDetalhes(
    int id,
  ) async {
    carregando = true;

    pokemonSelecionado = null;

    notifyListeners();

    pokemonSelecionado = await PokemonService.buscarDetalhes(
      id,
    );

    carregando = false;

    notifyListeners();
  }

  // PARTE 1: pesquisar pelo nome (devolve true se encontrou)
  Future<bool> pesquisarPorNome(
    String nome,
  ) async {
    carregando = true;

    pokemonSelecionado = null;

    notifyListeners();

    try {
      pokemonSelecionado = await PokemonService.buscarPorNome(
        nome,
      );
    } catch (e) {
      pokemonSelecionado = null;
    }

    carregando = false;

    notifyListeners();

    return pokemonSelecionado != null;
  }

  // PARTE 3: pokémon aleatório (devolve true se deu certo)
  Future<bool> carregarAleatorio() async {
    carregando = true;

    pokemonSelecionado = null;

    notifyListeners();

    try {
      pokemonSelecionado = await PokemonService.buscarAleatorio();
    } catch (e) {
      pokemonSelecionado = null;
    }

    carregando = false;

    notifyListeners();

    return pokemonSelecionado != null;
  }
}
