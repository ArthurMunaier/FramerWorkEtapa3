import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/pagina_inicial.dart';
import 'viewmodels/filme_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FilmeViewModel(),
      child: const MeuAplicativo(),
    ),
  );
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha Lista de Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PaginaInicial(),
    );
  }
}