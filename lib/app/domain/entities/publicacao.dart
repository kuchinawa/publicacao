import 'dart:typed_data';

class Publicacao {
  final int id;
  final String titulo;
  final String conteudo;
   Uint8List? imagem;

  Publicacao({
     required this.id,
    required this.titulo,
    required this.conteudo,
     this.imagem,
  });
}
