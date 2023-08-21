import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/publicacao.dart';
import '../../domain/interfaces/publicacao_dao.dart';

class PublicacaoDAOImpl implements PublicacaoDAO {
  late Database _db;

  PublicacaoDAOImpl() {
    _abrirBancoDados();
  }

  @override
  Future<void> inserirPublicacao(Publicacao publicacao) async {
    final db = await _abrirBancoDados();
    await db.insert(
      'publicacoes',
      {
        'titulo': publicacao.titulo,
        'conteudo': publicacao.conteudo,
        'imagem': publicacao.imagem,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<Database> _abrirBancoDados() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'banco_posts.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE publicacoes (
        id INTEGER PRIMARY KEY,
        titulo TEXT,
        conteudo TEXT,
        imagem BLOB
      );
    ''');
  }

  @override
  Future<void> atualizarPublicacao(Publicacao publicacao) async {
    _db = await _abrirBancoDados();
    await _db.update(
      'publicacoes',
      {
        'titulo': publicacao.titulo,
        'conteudo': publicacao.conteudo,
        'imagem': publicacao.imagem,
      },
      where: 'id = ?',
      whereArgs: [publicacao.id],
    );
  }

  @override
  Future<List<Publicacao>> buscarPublicacoes() async {
    _db = await _abrirBancoDados();
    final List<Map<String, dynamic>> maps = await _db.query('publicacoes');
    return List.generate(maps.length, (i) {
      return Publicacao(
        id: maps[i]['id'],
        titulo: maps[i]['titulo'],
        conteudo: maps[i]['conteudo'],
        imagem: maps[i]['imagem'],
      );
    });
  }

  @override
  Future<void> excluirPublicacao(int publicacaoId) async {
    _db = await _abrirBancoDados();
    await _db.delete(
      'publicacoes',
      where: 'id = ?',
      whereArgs: [publicacaoId],
    );
  }
}