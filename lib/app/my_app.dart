import 'package:flutter/material.dart';
import 'package:publicacao/app/view/adicionar_publicacao_screen.dart';
import 'package:publicacao/app/view/publicacoes_screen.dart';
import 'package:publicacao/app/view/tela_publicacoes.dart';

class MyApp extends StatelessWidget {
  static const HOME = '/';
  static const TELA_PUBLICACOES =  'tela-publicacoes';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Publicações App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),

    routes: {
    HOME : (context) => PublicacoesScreen(),
      TELA_PUBLICACOES : (context) => TelaPublicacoes()
    },
    );
  }
}