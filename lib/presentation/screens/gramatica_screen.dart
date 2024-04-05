import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar este paquete para acceder a la funcionalidad de clipboard
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'bxMajepJ0sQjZ1wO'; // Tu clave de API aquí
const String apiUrl = 'https://api.textgears.com/grammar';

class GramaticaScreen extends StatefulWidget {
  const GramaticaScreen({Key? key}) : super(key: key);

  @override
  State<GramaticaScreen> createState() => _GramaticaScreenState();
}

class _GramaticaScreenState extends State<GramaticaScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _analysisResult = '';

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Revisión de gramática',
        style: TextStyle(color: Color(0xFF101533)),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      iconTheme: const IconThemeData(color: Color(0xFF101533)),
    ),
    body: SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el texto',
                  fillColor: Color(0xFF101533),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(color: Color(0xFF101533)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(color: Color(0xFF101533), width: 2),
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    color: Color(0xFF101533),
                  ),
                ),
                style: const TextStyle(color: Color(0xFF101533)),
                maxLines: null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    _gramaticaText(_textEditingController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009EE1),
                  ),
                  child: const Text(
                    'Analizar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PoppinsSemiBold',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _analysisResult,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF101533),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    _copyCorrectedText();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009EE1),
                  ),
                  child: const Text(
                    'Copiar texto corregido',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PoppinsSemiBold',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Future<void> _gramaticaText(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'key': apiKey,
          'text': text,
          'language': 'es-ES',
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == true) {
          setState(() {
            _analysisResult = _formatAnalysisResult(text, result['response']);
          });
        } else {
          setState(() {
            _analysisResult = 'Error en el análisis: ${result['description']}';
          });
        }
      } else {
        setState(() {
          _analysisResult = 'Error en la solicitud: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _analysisResult = 'Error al realizar la solicitud HTTP: $e';
      });
    }
  }

  String _translateErrorType(String englishType) {
    // Mapeo de tipos de error de inglés a español
    final Map<String, String> translationMap = {
      'grammar': 'gramatical',
      'spelling': 'ortográfico',
      // Agrega más traducciones según sea necesario
    };

    // Busca la traducción correspondiente en el mapa
    final translatedType = translationMap[englishType.toLowerCase()];

    // Si se encuentra la traducción, devuélvela; de lo contrario, devuelve el tipo original
    return translatedType ?? englishType;
  }

  String _applyCorrections(String originalText, Map<String, dynamic> analysis) {
    final List<dynamic> errors = analysis['errors'];
    String correctedText = originalText;

    // Iterar sobre cada error y aplicar la corrección
    for (final error in errors) {
      final int offset = error['offset'] as int;
      final int length = error['length'] as int;
      final List<dynamic> betterList = error['better'] as List<dynamic>;
      final String better =
          betterList.isNotEmpty ? betterList.first as String : '';

      // Aplicar la corrección solo si la corrección no está vacía o nula
      if (better.isNotEmpty) {
        // Obtener el texto antes y después del error
        final String beforeError = correctedText.substring(0, offset);
        final String afterError = correctedText.substring(offset + length);

        // Construir el texto corregido
        correctedText = beforeError + better + afterError;
      }
    }

    return correctedText;
  }

  String _formatAnalysisResult(
      String originalText, Map<String, dynamic> analysis) {
    final StringBuffer formattedResult = StringBuffer();
    final errors = analysis['errors'] as List<dynamic>;
    for (final error in errors) {
      final englishType = error['type'];
      final type = _translateErrorType(englishType);
      final bad = error['bad'];
      final better = (error['better'] as List<dynamic>).join(', ');
      formattedResult.writeln('Tipo de error: $type');
      formattedResult.writeln('Error: $bad. \nSugerencias: $better\n');
    }

    final correctedText = _applyCorrections(originalText, analysis);
    formattedResult.writeln('Texto corregido:\n$correctedText');

    return formattedResult.toString();
  }

  void _copyCorrectedText() {
    final correctedText = _analysisResult.split('Texto corregido:\n')[1].trim();
    Clipboard.setData(ClipboardData(text: correctedText));
    const snackBar = SnackBar(
      content: Text('¡Texto corregido copiado al portapapeles!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
