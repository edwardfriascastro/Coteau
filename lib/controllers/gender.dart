// ignore_for_file: library_private_types_in_public_api, avoid_print
/*
Nombre: Jose Andres Trinidad Almeyda
Matricula: 2022-0575
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GenderView extends StatelessWidget {
  const GenderView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GenderPredictionScreen(),
    );
  }
}

class GenderPredictionScreen extends StatefulWidget {
  const GenderPredictionScreen({super.key});

  @override
  _GenderPredictionScreenState createState() => _GenderPredictionScreenState();
}

class _GenderPredictionScreenState extends State<GenderPredictionScreen> {
  String nombre = "";
  String genero = "Desconocido";

  Future<void> predecirGenero(String name) async {
    String apiUrl = "https://api.genderize.io/?name=$name";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = json.decode(response.body);

      setState(() {
        genero = data['gender'] ?? "Desconocido";
      });
    } catch (error) {
      print('Error al obtener el género: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción de Género'),
      ),
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: 630,
            height: 630,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(200, 48, 203, 37),
                  Color.fromARGB(105, 86, 215, 46)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      nombre = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Ingrese su nombre',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    predecirGenero(nombre);
                  },
                  child: const Text('Predecir Género'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Género Predicho: $genero',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 300,
                    height: 170,
                    decoration: BoxDecoration(
                        color: genero == 'male'
                            ? Colors.blue
                            : genero == 'female'
                                ? Colors.pink
                                : Colors.grey,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
