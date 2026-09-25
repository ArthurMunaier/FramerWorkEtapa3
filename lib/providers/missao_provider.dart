import 'package:flutter/material.dart';
import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final MissaoService service;

  MissaoProvider(this.service);

  List<Missao> missoes = [];
  bool carregando = false;

  int get pontosTotais {
    int total = 0;

    for (var missao in missoes) {
      if (missao.concluida) {
        total += missao.pontos;
      }
    }

    return total;
  }

  Future<void> carregarMissoes() async {
    carregando = true;
    notifyListeners();

    try {
      missoes = await service.buscarTodas();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> adicionarMissao(
    String titulo,
    String dificuldade,
  ) async {
    int pontos = 10;

    if (dificuldade == 'Médio') {
      pontos = 20;
    } else if (dificuldade == 'Difícil') {
      pontos = 30;
    }

    final missao = Missao(
      titulo: titulo,
      dificuldade: dificuldade,
      pontos: pontos,
    );

    await service.adicionar(missao);
    await carregarMissoes();
  }

  Future<void> concluirMissao(Missao missao) async {
    missao.concluida = true;
    await service.atualizar(missao);
    await carregarMissoes();
  }

  Future<void> excluirMissao(String id) async {
    await service.excluir(id);
    await carregarMissoes();
  }
}
