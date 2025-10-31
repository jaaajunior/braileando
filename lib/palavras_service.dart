import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class Palavra {
  final String nivel;
  final String palavra;
  final String dica;

  Palavra({required this.nivel, required this.palavra, required this.dica});

  factory Palavra.fromJson(Map<String, dynamic> json) {
    return Palavra(
      nivel: json['nivel'],
      palavra: json['palavra'],
      dica: json['dica'],
    );
  }
}

class PalavrasService {
  List<Palavra> _todasPalavras = [];

  Future<void> carregarPalavras() async {
    final String jsonString = await rootBundle.loadString('assets/palavras.json');
    final dados = jsonDecode(jsonString);
    _todasPalavras = List<Palavra>.from(dados['palavras'].map((p) => Palavra.fromJson(p)));
  }

  Palavra buscarPalavraPorNivel(String nivel) {
    final palavrasFiltradas = _todasPalavras.where((p) => p.nivel == nivel).toList();
    if (palavrasFiltradas.isEmpty) {
      throw Exception("Nenhuma palavra encontrada para o nível $nivel");
    }
    final random = Random();
    return palavrasFiltradas[random.nextInt(palavrasFiltradas.length)];
  }
}
