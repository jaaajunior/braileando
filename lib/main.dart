import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const BraileandoApp());
}

class BraileandoApp extends StatelessWidget {
  const BraileandoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BRAILEANDO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 20, color: Colors.white70),
          labelLarge: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: const Color(0xFF2C5788),
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF203A43),
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final FlutterTts flutterTts = FlutterTts();
  bool _mensagemJaFoiLida = false;

  @override
  void initState() {
    super.initState();
    _configurarTTS();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _configurarTTS() async {
    if (!_mensagemJaFoiLida) {
      await flutterTts.setLanguage('pt-BR');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(
        'Bem-vindo ao Braileando, um aplicativo de apoio à alfabetização. '
        'Esta é uma iniciativa do mestrando Lucas Reis, desenvolvida como produto educacional '
        'para o Programa de Pós-Graduação em Educação Científica, Inclusão e Diversidade da UFRB.'
      );
      setState(() {
        _mensagemJaFoiLida = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png'),
                  const SizedBox(height: 20),
                  Semantics(
                    header: true,
                    child: Text(
                      'PPGECID',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withAlpha(128),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Creator: By Lucas Reis',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: Colors.grey[300],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SelecaoNivel()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C5364),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.blue.withAlpha(128),
                    ),
                    child: Semantics(
                      label: 'Iniciar Jogo',
                      child: Text('Iniciar Jogo', style: Theme.of(context).textTheme.labelLarge),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientPainter extends CustomPainter {
  const GradientPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0F2027),
          Color(0xFF203A43),
          Color(0xFF2C5364),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SelecaoNivel extends StatelessWidget {
  const SelecaoNivel({super.key});

  @override
  Widget build(BuildContext context) {
    final niveis = ['1º Ano', '2º Ano', '3º Ano'];
    return Scaffold(
      appBar: AppBar(title: const Text('Selecione o Nível')),
      body: ListView.builder(
        itemCount: niveis.length,
        itemBuilder: (context, index) {
          final nivel = niveis[index];
          return ListTile(
            title: Text(nivel, style: Theme.of(context).textTheme.labelLarge),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaJogo(nivel: 'nivel_${index + 1}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TelaJogo extends StatefulWidget {
  final String nivel;
  const TelaJogo({super.key, required this.nivel});

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  final FlutterTts flutterTts = FlutterTts();
  List<Map<String, dynamic>> palavras = [];
  late String palavraSecreta;
  late String dicaAtual;
  List<String> letrasCorretas = [];
  List<String> letrasIncorretas = [];
  int tentativasRestantes = 6;
  bool dicaJaFoiLida = false;
  final TextEditingController _textEditingController = TextEditingController();
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _configurarTTS();
    _carregarPalavras();
  }

  Future<void> _configurarTTS() async {
    await flutterTts.setLanguage('pt-BR');
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _lerDica() async {
    if (!dicaJaFoiLida) {
      await flutterTts.speak('Dica: $dicaAtual');
      dicaJaFoiLida = true;
    }
  }

  Future<void> _carregarPalavras() async {
    try {
      final dados = await rootBundle.loadString('assets/palavras.json');
      final json = jsonDecode(dados);
      final nivelSelecionado = '${widget.nivel.replaceAll('nivel_', '')}º ano';
      
      setState(() {
        palavras = List<Map<String, dynamic>>.from(
          json['palavras'].where((p) => p['nivel'] == nivelSelecionado)
        );
        
        if (palavras.isEmpty) {
          throw Exception('Nenhuma palavra encontrada para o nível selecionado');
        }
        
        final palavraAleatoria = (palavras..shuffle()).first;
        palavraSecreta = palavraAleatoria['palavra'].toString().toUpperCase();
        dicaAtual = palavraAleatoria['dica'].toString();
        carregando = false;
        dicaJaFoiLida = false;
      });

      await flutterTts.speak('A palavra tem ${palavraSecreta.length} letras');
    } catch (e) {
      debugPrint('Erro ao carregar palavras: $e');
      setState(() {
        palavras = [
          {'palavra': 'FLUTTER', 'dica': 'Framework de desenvolvimento'},
          {'palavra': 'BRAILLE', 'dica': 'Sistema de leitura tátil'},
          {'palavra': 'TECLADO', 'dica': 'Usado para digitar'},
          {'palavra': 'INCLUSAO', 'dica': 'Tornar algo parte de um todo'},
          {'palavra': 'EDUCACAO', 'dica': 'Processo de ensino e aprendizagem'},
          {'palavra': 'CIENCIA', 'dica': 'Conhecimento sistemático'}
        ];
        final palavraAleatoria = (palavras..shuffle()).first;
        palavraSecreta = palavraAleatoria['palavra'].toString().toUpperCase();
        dicaAtual = palavraAleatoria['dica'].toString();
        carregando = false;
        dicaJaFoiLida = false;
      });

      await flutterTts.speak('A palavra tem ${palavraSecreta.length} letras');
    }
  }

  String get palavraEscondidaVisual {
    return palavraSecreta.split('').map((letra) {
      return letrasCorretas.contains(letra) ? '$letra ' : '_ ';
    }).join();
  }

  void tentarLetra(String letra) async {
    letra = letra.toUpperCase();
    if (letra.isEmpty) return;
    
    if (letrasCorretas.contains(letra) || letrasIncorretas.contains(letra)) {
      await flutterTts.speak('Esta letra já foi digitada anteriormente');
      return;
    }

    if (palavraSecreta.contains(letra)) {
      setState(() => letrasCorretas.add(letra));
      await flutterTts.speak(letra);
    } else {
      setState(() {
        letrasIncorretas.add(letra);
        tentativasRestantes--;
      });
      await flutterTts.speak('Letra errada');
      
      // Lê a dica após dois erros
      if (letrasIncorretas.length == 2) {
        await _lerDica();
      }
    }

    if (palavraSecreta.split('').every((letra) => letrasCorretas.contains(letra))) {
      await flutterTts.speak('Parabéns! Você descobriu a palavra $palavraSecreta');
      _mostrarDialogo('Parabéns!', 'Você venceu!');
    } else if (tentativasRestantes == 0) {
      await flutterTts.speak('Fim de jogo. A palavra era $palavraSecreta');
      _mostrarDialogo('Fim de jogo', 'A palavra era: $palavraSecreta');
    }
  }

  void _mostrarDialogo(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Voltar'),
          ),
          if (titulo == 'Parabéns!')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  letrasCorretas = [];
                  letrasIncorretas = [];
                  tentativasRestantes = 6;
                  dicaJaFoiLida = false;
                  carregando = true;
                });
                _carregarPalavras();
              },
              child: const Text('Nova Palavra'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Jogo da Forca')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              palavraEscondidaVisual,
              style: const TextStyle(fontSize: 32, letterSpacing: 2),
            ),
            const SizedBox(height: 20),
            Text(
              'Dica: $dicaAtual',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Digite uma letra',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                tentarLetra(value);
                _textEditingController.clear();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                tentarLetra(_textEditingController.text);
                _textEditingController.clear();
              },
              child: const Text('Tentar Letra'),
            ),
            const SizedBox(height: 20),
            Text(
              'Erros: ${letrasIncorretas.join(', ')}',
              style: const TextStyle(color: Colors.redAccent),
            ),
            Text('Tentativas restantes: $tentativasRestantes'),
          ],
        ),
      ),
    );
  }
}

// Widget de teste para verificar o gradiente isoladamente
class TesteGradiente extends StatelessWidget {
  const TesteGradiente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
      ),
    );
  }
}
