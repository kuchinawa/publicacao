import 'package:flutter/material.dart';
import '../database/dao/publicacao_dao_impl.dart';
import '../domain/entities/publicacao.dart';
import '../domain/interfaces/publicacao_dao.dart';
import 'EditarPublicacaoScreen.dart';
import 'adicionar_publicacao_screen.dart';

class PublicacoesScreen extends StatefulWidget {
  @override
  _PublicacoesScreenState createState() => _PublicacoesScreenState();
}

class _PublicacoesScreenState extends State<PublicacoesScreen> {
  late Future<List<Publicacao>> _publicacoesFuture;
  final PublicacaoDAO _publicacaoDAO = PublicacaoDAOImpl();

  @override
  void initState() {
    super.initState();
    _publicacoesFuture = _buscarPublicacoes();
  }

  Future<List<Publicacao>> _buscarPublicacoes() async {
    return await _publicacaoDAO.buscarPublicacoes();
  }

  Future<void> _exibirConfirmacaoExclusao(int publicacaoId) async {
    bool confirmacao = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir esta publicação?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Resposta: não
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Resposta: sim
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmacao == true) {
      _excluirPublicacao(publicacaoId);
    }
  }

  Future<void> _excluirPublicacao(int publicacaoId) async {
    await _publicacaoDAO.excluirPublicacao(publicacaoId);
    setState(() {
      _publicacoesFuture = _buscarPublicacoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicações'),
      ),
      body: FutureBuilder<List<Publicacao>>(
        future: _publicacoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar as publicações'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma publicação encontrada'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final publicacao = snapshot.data![index];
                return ListTile(
                  title: Text(publicacao.titulo),
                  subtitle: Text(publicacao.conteudo),
                  leading: publicacao.imagem != null
                      ? Image.memory(publicacao.imagem!)
                      : Icon(Icons.image_not_supported),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navegar para a tela de edição
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditarPublicacaoScreen(publicacao: publicacao),
                            ),
                          ).then((value) {
                            setState(() {
                              _publicacoesFuture = _buscarPublicacoes();
                            });
                          });
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          // Exibir confirmação de exclusão
                          _exibirConfirmacaoExclusao(publicacao.id);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar para a tela de adicionar publicação
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarPublicacaoScreen()),
          );

          setState(() {
            _publicacoesFuture = _buscarPublicacoes();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
