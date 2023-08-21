import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/dao/publicacao_dao_impl.dart';
import '../domain/entities/publicacao.dart';
import '../domain/interfaces/publicacao_dao.dart';

class EditarPublicacaoScreen extends StatefulWidget {
  final Publicacao publicacao;

  EditarPublicacaoScreen({required this.publicacao});

  @override
  _EditarPublicacaoScreenState createState() => _EditarPublicacaoScreenState();
}

class _EditarPublicacaoScreenState extends State<EditarPublicacaoScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _conteudoController = TextEditingController();
  Uint8List? _imagemBytes;

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.publicacao.titulo;
    _conteudoController.text = widget.publicacao.conteudo;
    _imagemBytes = widget.publicacao.imagem;
  }

  Future<void> _atualizarPublicacao() async {
    String titulo = _tituloController.text;
    String conteudo = _conteudoController.text;

    if (titulo.isEmpty || conteudo.isEmpty) {
      // Lógica de validação aqui (mostrar alerta)
      return;
    }

    Publicacao publicacaoAtualizada = Publicacao(
      id: widget.publicacao.id,
      titulo: titulo,
      conteudo: conteudo,
      imagem: _imagemBytes!,
    );

    await _atualizarPublicacaoNoBanco(publicacaoAtualizada);

    Navigator.pop(context);
  }

  Future<void> _atualizarPublicacaoNoBanco(Publicacao publicacao) async {
    final PublicacaoDAO publicacaoDAO = PublicacaoDAOImpl();
    await publicacaoDAO.atualizarPublicacao(publicacao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Publicação'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _conteudoController,
              decoration: InputDecoration(labelText: 'Conteúdo'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

                if (pickedImage != null) {
                  List<int> imageBytes = await pickedImage.readAsBytes();
                  setState(() {
                    _imagemBytes = Uint8List.fromList(imageBytes);
                  });
                }
              },
              child: Text('Alterar Imagem'),
            ),
            SizedBox(height: 16.0),
            _imagemBytes != null
                ? Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(_imagemBytes!),
                  fit: BoxFit.cover,
                ),
              ),
            )
                : SizedBox(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _atualizarPublicacao,
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
