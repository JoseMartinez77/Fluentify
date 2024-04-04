import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'bxMajepJ0sQjZ1wO'; // Reemplaza con tu clave de API real
const String apiUrl = 'https://api.textgears.com/summarize';

class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _analysisResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resumen y palabras clave',
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
                      _resumenText(_textEditingController.text);
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

  Future<void> _resumenText(String text) async {
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
        final response = result['response'];
        List<String> keywords = List<String>.from(response['keywords'] ?? []);
        List<String> highlight = List<String>.from(response['highlight'] ?? []);
        List<String> summary = List<String>.from(response['summary'] ?? []);

        setState(() {
          _analysisResult =
              '  • Palabras clave: ${keywords.join(", ")}\n\n  • Highlight:\n${highlight.join("\n")}\n\n  • Resumen:\n${summary.join("\n")}';
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
}
