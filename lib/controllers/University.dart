// ignore_for_file: library_private_types_in_public_api, avoid_print, file_names
/*
Nombre: Jose Andres Trinidad Almeyda
Matricula: 2022-0575
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UniversityView extends StatelessWidget {
  const UniversityView({super.key });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UniversityListScreen(),
    );
  }
}

class UniversityListScreen extends StatefulWidget {
  const UniversityListScreen({super.key});

  @override
  _UniversityListScreenState createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  List<University> universities = [];

  Future<void> fetchUniversities(String country) async {
    final response = await http.get(Uri.parse(
      'http://universities.hipolabs.com/search?country=$country',
    ));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        universities = data.map((item) => University.fromJson(item)).toList();
      });
    } else {
      print('Error al cargar universidades. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades por País'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (country) {
                if (country.isNotEmpty) {
                  fetchUniversities(country);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Ingrese el nombre del país en inglés',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: universities.length,
                itemBuilder: (context, index) {
                  final university = universities[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Text(university.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dominio: ${university.domains.join(", ")}'),
                          const SizedBox(height:4),
                          Text('Sitio Web: ${university.webPage}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class University {
  final String name;
  final List<String> domains;
  final String webPage;

  University({
    required this.name,
    required this.domains,
    required this.webPage,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] ?? '',
      domains: (json['domains'] as List<dynamic>?)?.cast<String>() ?? [],
      webPage: json['web_pages'][0] ?? '',
    );
  }
}
