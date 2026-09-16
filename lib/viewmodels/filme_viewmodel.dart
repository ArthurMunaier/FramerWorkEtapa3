import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../services/filme_service.dart';

class FilmeViewModel extends ChangeNotifier {
  final FilmeService service = FilmeService();

  List<Filme> filmes = [];

  Future<void> carregarFilmes() async {
    filmes = await service.listarFilmes();

    notifyListeners();
  }

  Future<void> adicionarFilme(String titulo) async {
    if (titulo.trim().isEmpty) {
      return;
    }

    Filme filme = Filme(
      titulo: titulo.trim(),
      assistido: false,
    );

    await service.inserirFilme(filme);

    await carregarFilmes();
  }

  Future<void> alterarAssistido(Filme filme) async {
    filme.assistido = !filme.assistido;

    await service.atualizarFilme(filme);

    notifyListeners();
  }
}