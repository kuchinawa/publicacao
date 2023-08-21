

import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:publicacao/app/database/dao/publicacao_dao_impl.dart';
import 'package:publicacao/app/domain/entities/publicacao.dart';

class AdicionarPublicacaoScreen extends StatefulWidget {
  @override
  _AdicionarPublicacaoScreenState createState() => _AdicionarPublicacaoScreenState();
}

class _AdicionarPublicacaoScreenState extends State<AdicionarPublicacaoScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _conteudoController = TextEditingController();
  Uint8List? _imagemBytes;

  Future<void> _adicionarPublicacao() async {
    String titulo = _tituloController.text;
    String conteudo = _conteudoController.text;

    if (titulo.isEmpty || conteudo.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Campos obrigatórios'),
            content: Text('Os campos Título e Conteúdo são obrigatórios.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    Publicacao novaPublicacao = Publicacao(
      id: DateTime.now().millisecondsSinceEpoch,
      titulo: titulo,
      conteudo: conteudo,
      imagem: _imagemBytes!,
    );

    await _inserirPublicacao(novaPublicacao);

    Navigator.pop(context);
  }

  Future<void> _inserirPublicacao(Publicacao publicacao) async {
    PublicacaoDAOImpl publicacaoDAO = PublicacaoDAOImpl();
    await publicacaoDAO.inserirPublicacao(publicacao);
  }


  Widget _buildImagePreview() {
    if (_imagemBytes != null) {
      return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(_imagemBytes!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Publicação'),
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
              child: Text('Adicionar Imagem'),
            ),
            SizedBox(height: 16.0),
            _buildImagePreview(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _adicionarPublicacao,
              child: Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }
}
