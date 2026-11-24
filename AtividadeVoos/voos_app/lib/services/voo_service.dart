import 'dart:convert';

import 'package:http/http.dart' as http;

class VooService {
  static const String url = 'http://127.0.0.1:5001/api/voos';

  // GET /api/voos?aeroporto=SBGR&tipo=chegadas
  static Future<List<dynamic>> buscarVoos(
    String aeroporto,
    String tipo,
  ) async {
    final uri = Uri.parse(url).replace(
      queryParameters: {
        'aeroporto': aeroporto,
        'tipo': tipo,
      },
    );

    http.Response resposta;

    try {
      resposta = await http.get(uri);
    } catch (e) {
      throw Exception(
        'API não respondeu. O Python (app.py) está rodando?',
      );
    }

    final dados = jsonDecode(resposta.body);

    if (resposta.statusCode == 200) {
      return dados['voos'];
    }

    // a API devolve {"erro": "mensagem"} quando algo dá errado
    throw Exception(
      dados['erro'] ?? 'Erro ao buscar voos',
    );
  }
}
