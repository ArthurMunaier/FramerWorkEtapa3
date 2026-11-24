import 'package:flutter/material.dart';

import '../services/voo_service.dart';

class VooProvider extends ChangeNotifier {
  List<dynamic> voos = [];

  bool carregando = false;

  String? erro;

  String aeroporto = 'SBGR';

  String tipo = 'chegadas';

  // Busca de novo na API. Se receber aeroporto/tipo, atualiza antes de buscar.
  Future<void> buscarVoos({
    String? aeroporto,
    String? tipo,
  }) async {
    if (aeroporto != null) this.aeroporto = aeroporto.trim().toUpperCase();
    if (tipo != null) this.tipo = tipo;

    carregando = true;

    erro = null;

    notifyListeners();

    try {
      voos = await VooService.buscarVoos(
        this.aeroporto,
        this.tipo,
      );
    } catch (e) {
      voos = [];

      erro = e.toString().replaceFirst('Exception: ', '');
    }

    carregando = false;

    notifyListeners();
  }
}
