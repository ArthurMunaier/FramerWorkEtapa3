import 'package:flutter/material.dart';

class DetalhesPage extends StatelessWidget {
  final Map<String, dynamic> voo;

  const DetalhesPage({
    super.key,
    required this.voo,
  });

  Widget linha(String titulo, dynamic valor) {
    return ListTile(
      title: Text(titulo),
      subtitle: Text(
        '${valor ?? '-'}',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${voo['identificacao']}'),
      ),
      body: ListView(
        children: [
          linha('Identificação', voo['identificacao']),
          linha('Categoria', voo['categoria']),
          linha('Aeronave', voo['tipo_aeronave']),
          linha('Origem / Destino', voo['local']),
          linha('Partida', voo['partida']),
          linha('Chegada', voo['chegada']),
        ],
      ),
    );
  }
}
