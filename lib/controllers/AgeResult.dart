// ignore_for_file: library_private_types_in_public_api, avoid_print, file_names, sized_box_for_whitespace
/*
Nombre: Jose Andres Trinidad Almeyda
Matricula: 2022-0575
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgeView extends StatelessWidget {
  const AgeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgePredictionScreen(),
    );
  }
}

class AgePredictionScreen extends StatefulWidget {
  const AgePredictionScreen({super.key});

  @override
  _AgePredictionScreenState createState() => _AgePredictionScreenState();
}

class _AgePredictionScreenState extends State<AgePredictionScreen> {
  String nombre = "";
  int edad = 0;
  String estado = "";

  Future<void> predecirEdad(String name) async {
    String apiUrl = "https://api.agify.io/?name=$name";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = json.decode(response.body);

      setState(() {
        edad = data['age'] ?? 0;
        determinarEstado();
      });
    } catch (error) {
      print('Error al obtener la edad: $error');
    }
  }

  void determinarEstado() {
    if (edad < 14) {
      estado = 'Niño/a';
    } else if (edad < 19) {
      estado = 'Adolescente';
    } else if (edad < 29) {
      estado = 'Adulto Joven';
      // Especificaciones para Adulto Joven
      if (edad < 18) {
        estado += ' - Menor de Edad';
      } else {
        estado += ' - Mayor de Edad';
      }
    } else if (edad < 39) {
      estado = 'Adulto';
      // Especificaciones para Adulto
      // Puedes agregar más detalles según sea necesario
    } else if (edad < 59) {
      estado = 'Adulto de mediana edad';
      // Especificaciones para Adulto de mediana edad
    } else if (edad < 100) {
      estado = 'Anciano';
      // Especificaciones para Anciano
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción de Edad'),
      ),
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: 620,
            height: 620,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.blue],
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
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () {
                    predecirEdad(nombre);
                  },
                  child: const Text('Predecir Edad'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Edad Predicha: $edad',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Estado: $estado',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 300,
                  height: 164,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          estado == 'Niño/a'
                              ? 'assets/img/Child.jpeg'
                              : estado == 'Adolescente'
                                  ? 'assets/img/Teenage.jpeg'
                                  : estado == 'Adulto Joven'
                                      ? 'assets/img/YoungAdult.jpeg'
                                      : estado == 'Adulto'
                                          ? 'assets/img/Adult.jpeg'
                                          : estado == 'Adulto de mediana edad'
                                              ? 'assets/img/MiddleAged.jpeg'
                                              : 'assets/img/OldMan.jpeg',
                          height: 120,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$edad',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
}
