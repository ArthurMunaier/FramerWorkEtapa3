import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComentarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> acompanharPublicacao(
      String publicacaoId) {
    return _db.collection('publicacoes').doc(publicacaoId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> acompanharComentarios(
      String publicacaoId) {
    return _db
        .collection('comentarios')
        .where('publicacaoId', isEqualTo: publicacaoId)
        .snapshots();
  }

  Future<void> comentar(String publicacaoId, String texto) async {
    final usuario = _auth.currentUser!;
    final perfil = await _db.collection('usuarios').doc(usuario.uid).get();
    final nome = (perfil.data()?['nome'] as String?) ?? 'Usuário';
    await _db.collection('comentarios').add({
      'texto': texto.trim(),
      'autorNome': nome,
      'autorId': usuario.uid,
      'publicacaoId': publicacaoId,
      'data': FieldValue.serverTimestamp(),
    });
  }

  Future<void> excluir(String comentarioId) =>
      _db.collection('comentarios').doc(comentarioId).delete();
}
