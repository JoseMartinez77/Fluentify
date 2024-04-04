import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'bxMajepJ0sQjZ1wO'; // Reemplaza con tu clave de API real
const String apiUrl = 'https://api.textgears.com/readability';

class LegibilidadScreen extends StatefulWidget {
  const LegibilidadScreen({super.key});

  @override
  State<LegibilidadScreen> createState() => _LegibilidadScreenState();
}

class _LegibilidadScreenState extends State<LegibilidadScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _analysisResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Legibilidad',
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
                        borderSide:
                            BorderSide(color: Color(0xFF101533), width: 2),
                      ),
                      labelStyle: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          color: Color(0xFF101533))),
                  style: const TextStyle(color: Color(0xFF101533)),
                  maxLines: null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      _legibilidadText(_textEditingController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009EE1),
                    ),
                    child: const Text(
                      'Analizar',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'PoppinsSemiBold'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _analysisResult,
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xFF101533)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _legibilidadText(String text) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'key': apiKey,
        'text': text,
        'language': 'es-ES',
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == true) {
        final analysisResponse = result['response'];
        String analysisResultTemp = '';

        // Mostrar estadísticas de legibilidad
        analysisResultTemp += _extractReadabilityStats(analysisResponse);

        // Mostrar estadísticas de emoción
        analysisResultTemp += _extractEmotionStats(analysisResponse);

        // Mostrar estadísticas contadores
        analysisResultTemp += _counterStats(analysisResponse);

        setState(() {
          _analysisResult = analysisResultTemp;
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
  }

  String _extractReadabilityStats(Map<String, dynamic> analysisResponse) {
    if (analysisResponse.containsKey('stats')) {
      final readabilityStats = analysisResponse['stats'];
      String readabilityText = '\nEstadísticas de legibilidad:\n';
      readabilityText +=
          '  • Índice de Flesch-Kincaid: ${readabilityStats['fleschKincaid']['readingEase']}';
      readabilityText +=
          '\n     - Grado: ${readabilityStats['fleschKincaid']['grade']}\n';
      readabilityText +=
          '     - Interpretación: ${readabilityStats['fleschKincaid']['interpretation']}\n';
      readabilityText +=
          '  • Índice de Gunning Fog: ${readabilityStats['gunningFog']}\n';
      readabilityText +=
          '  • Índice de Coleman-Liau: ${readabilityStats['colemanLiau']}\n';
      readabilityText += '  • Índice de SMOG: ${readabilityStats['SMOG']}\n';

      return readabilityText;
    }

    return '';
  }

  String _extractEmotionStats(Map<String, dynamic> analysisResponse) {
    if (analysisResponse.containsKey('stats') &&
        analysisResponse['stats'].containsKey('emotion')) {
      final emotionStats = analysisResponse['stats']['emotion'];
      String emotionText = '\nEstadísticas de Emoción:\n';
      emotionText += '  • Positivo: ${emotionStats['positive']}\n';
      emotionText += '  • Negativo: ${emotionStats['negative']}\n';

      return emotionText;
    }

    return '';
  }

  String _counterStats(Map<String, dynamic> analysisResponse) {
    if (analysisResponse.containsKey('stats') &&
        analysisResponse['stats'].containsKey('counters')) {
      final countersStats = analysisResponse['stats']['counters'];
      String counterText = '\nEstadísticas de conteo:\n';
      counterText += '  • Longitud: ${countersStats['length']}\n';
      counterText += '  • Longitud clara: ${countersStats['clearLength']}\n';
      counterText += '  • Palabras: ${countersStats['words']}\n';
      counterText += '  • Frases: ${countersStats['sentences']}\n';

      return counterText;
    }

    return '';
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
