import 'package:fluentify/presentation/screens/idioma_screen.dart';
import 'package:fluentify/presentation/screens/legibilidad_screen.dart';
import 'package:fluentify/presentation/screens/ortografia_screen.dart';
import 'package:fluentify/presentation/screens/resumen_screen.dart';
import 'package:fluentify/presentation/screens/gramatica_screen.dart';
import 'package:fluentify/presentation/screens/revision_complete_screen.dart';
import 'package:fluentify/presentation/screens/about_us.dart';
import 'package:fluentify/presentation/screens/rate_us.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final List<CustomCardCarousel> customCards = [
      CustomCardCarousel(
        title: 'Gramatica',
        description:
            '\nComprobar errores: \n- Gramaticales \n- Ortográficos \n- Puntuación \n- Estilo.',
        //image: const AssetImage('assets/images/gramatica.png'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GramaticaScreen()),
          );
        },
      ),
      CustomCardCarousel(
        title: 'Ortografia',
        description: '\n- Busqueda de errores tipográficos.',
        //image: const AssetImage('assets/images/gramatica.png'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrtografiaScreen()),
          );
        },
      ),
      CustomCardCarousel(
        title: 'Legibilidad',
        description:
            '\nCálculo de la legibilidad del texto según: \n- Algoritmos. \n- Adaptaciones de los idiomas.',
        //image: const AssetImage('assets/images/gramatica.png'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LegibilidadScreen()),
          );
        },
      ),
      CustomCardCarousel(
        title: 'Resumen',
        description:
            '\n- Generacion de un resumen. \n- Busqueda de palabras clave.',
        //image: const AssetImage('assets/images/gramatica.png'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResumenScreen()),
          );
        },
      ),
      /*CustomCardCarousel(
        title: 'Diccionario',
        description: '',
        //image: const AssetImage('assets/images/gramatica.png'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiccionarioScreen()),
          );
        },
      ),*/
      CustomCardCarousel(
        title: 'Idioma',
        description:
            '\n- Determinación del idioma del texto. \n- Suposición de su dialecto.',
        //image: const AssetImage('assets/images/gramatica.png'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IdiomaScreen()),
          );
        },
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Fluentify',
          style: TextStyle(
              fontFamily: 'PoppinsBold',
              fontSize: 35,
              fontWeight: FontWeight.w800,
              color: Color(0xFF101533)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: const Color(0xFF101533),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF009EE1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    // Aquí puedes agregar una imagen para el avatar
                    backgroundImage: AssetImage('assets/images/perfil.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menú',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'PoppinsSemiBold'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'Acerca de nosotros',
                style: TextStyle(
                  fontFamily: 'PoppinsMedium',
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUs()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Califícanos',
                style: TextStyle(
                  fontFamily: 'PoppinsMedium',
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RateUs()),
                );
              },
            )
          ],
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              const Center(
                child: Text(
                  'Eleva tu escritura',
                  style: TextStyle(
                      fontFamily: 'PoppinsMedium',
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101533)),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: CustomCardRevisionComplete(
                  title: 'Revisión completa',
                  description:
                      '\n- Análisis exhaustivo del texto. \n- Calcula las métricas de legibilidad. \n- Califica la ortografía. \n- Evalúa el estado emocional del texto.',
                  //image: const AssetImage('assets/images/revision.png'),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RevisionCompleteScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text('Funciones individuales',
                    style: TextStyle(
                      color: Color(0xFF101533),
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                      fontFamily: 'PoppinsMedium',
                    )),
              ),
              const SizedBox(height: 20),
              CarouselSlider(
                items: customCards.map((card) => card).toList(),
                options: CarouselOptions(autoPlay: true, height: 325),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Versión 1.0.0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF101533),
                    fontFamily: 'PoppinsRegular',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardRevisionComplete extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final String description;

  const CustomCardRevisionComplete({
    super.key,
    this.onPressed,
    required this.description,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 325,
      child: Card(
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        surfaceTintColor: const Color.fromARGB(123, 255, 255, 255),
        elevation: 10,
        color: const Color.fromARGB(255, 244, 244, 244),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        margin: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF0D0D0D),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PoppinsMedium',
                ),
              ),
              subtitle: Text(
                description,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 17,
                ),
              ),
            ),
            Expanded(
              child: Container(), // This will push the button to the bottom
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15), // Adjust the space here
              child: SizedBox(
                width: 150,
                height: 50,
                child: TextButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009EE1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  child: const Text(
                    '¡Vamos!',
                    style: TextStyle(
                      color: Color(0xFFF2F2F2),
                      fontSize: 18,
                      fontFamily: 'PoppinsSemiBold',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CustomCardCarousel extends StatelessWidget {
  final VoidCallback? onPressed;
  //final ImageProvider<Object> image;
  final String title;
  final String description;

  const CustomCardCarousel({
    super.key,
    this.onPressed,
    required this.description,
    required this.title,
    //required this.image
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        surfaceTintColor: const Color.fromARGB(123, 255, 255, 255),
        elevation: 10,
        color: const Color.fromARGB(255, 244, 244, 244),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        margin: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF0D0D0D),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PoppinsMedium',
                ),
              ),
              subtitle: Text(
                description,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 17,
                ),
              ),
            ),
            /*Image(
            image: image, 
            width: 70, 
            height: 70,
          ),*/
           Expanded(
              child: Container(), // This will push the button to the bottom
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15), // Adjust the space here
              child: SizedBox(
                width: 150,
                height: 50,
                child: TextButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009EE1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  child: const Text(
                    '¡Vamos!',
                    style: TextStyle(
                      color: Color(0xFFF2F2F2),
                      fontSize: 18,
                      fontFamily: 'PoppinsSemiBold',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
