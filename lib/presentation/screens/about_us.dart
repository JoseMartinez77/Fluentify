import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de nosotros'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              // Aquí puedes agregar una imagen para representar tu equipo o empresa
              backgroundImage: AssetImage('assets/images/playstore.png'),
            ),
            SizedBox(height: 20),
            Text(
              'JASotware es una empresa dedicada al desarrollo de software innovador y que deje una huella en la sociedad',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Contáctanos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Correo electrónico: gr441131@uaeh.edu.mx.com\nTeléfono: (+52) 772 155 4599',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}