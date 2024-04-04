import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'bxMajepJ0sQjZ1wO'; // Tu clave de API aquí
const String apiUrl = 'https://api.textgears.com/spelling';

class OrtografiaScreen extends StatefulWidget {
  const OrtografiaScreen({Key? key}) : super(key: key);

  @override
  State<OrtografiaScreen> createState() => _OrtografiaScreenState();
}

class _OrtografiaScreenState extends State<OrtografiaScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _analysisResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Revisión de ortografía',
          style: TextStyle(color: Color(0xFF101533)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        iconTheme: const IconThemeData(color: Color(0xFF101533)),
      ),
      body: Container(
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
                    fontFamily: 'PoppinsSemiBold',
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
                    _ortografiaText(_textEditingController.text);
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
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _analysisResult,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF101533),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _ortografiaText(String text) async {
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
        final errors = result['response']['errors'] as List<dynamic>;
        final errorMessages = errors.map((error) {
          final bad = error['bad'];
          final better = (error['better'] as List<dynamic>).join(', ');
          final description =
              error['description'].toString(); // Convertir a cadena de texto
          // Extraer la parte deseada de la descripción si existe
          final start = description.indexOf('¿Quería decir');
          final end = description.lastIndexOf('?') + 1;
          final cleanDescription = start != -1
              ? description.substring(start, end).trim()
              : description;
          // Eliminar cualquier cadena que comience con "{xx:" donde xx es cualquier código de idioma
          final cleanDescriptionFinal =
              cleanDescription.replaceAll(RegExp(r'\{.*?:|}\.?'), '');
          return 'Error: $bad. \nDescripción: $cleanDescriptionFinal. \nSugerencias: $better';
        }).join('\n\n');
        setState(() {
          _analysisResult = errorMessages;
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
