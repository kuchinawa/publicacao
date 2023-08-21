import 'package:sqflite/sqflite.dart';
import '../entities/publicacao.dart';

abstract class PublicacaoDAO {
  Future<void> inserirPublicacao(Publicacao publicacao);
  Future<List<Publicacao>> buscarPublicacoes();
  Future<void> atualizarPublicacao(Publicacao publicacao);
  Future<void> excluirPublicacao(int publicacaoId);
}
