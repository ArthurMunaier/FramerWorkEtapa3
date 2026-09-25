import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/missao.dart';

class MissaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionar(Missao missao) async {
    await _firestore.collection('missoes').add(missao.toMap());
  }

  Future<List<Missao>> buscarTodas() async {
    final resultado = await _firestore
        .collection('missoes')
        .orderBy('titulo')
        .get();

    return resultado.docs
        .map((doc) => Missao.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> atualizar(Missao missao) async {
    await _firestore
        .collection('missoes')
        .doc(missao.id)
        .update(missao.toMap());
  }

  Future<void> excluir(String id) async {
    await _firestore.collection('missoes').doc(id).delete();
  }
}
