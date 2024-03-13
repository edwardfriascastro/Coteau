// ignore_for_file: library_private_types_in_public_api, avoid_print, unnecessary_string_interpolations
/*
Nombre: Jose Andres Trinidad Almeyda
Matricula: 2022-0575
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WeatherView(),
  ));
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String apiKey = '';
  double currentTemperature = 0;
  String currentCondition = '';
  bool showHourly = false;
  List<HourlyForecast> hourlyForecasts = [];

  Future<void> fetchWeather() async {
    String apiUrl =
        'https://www.meteosource.com/api/v1/free/point?lat=18.4667N&lon=69.8333W&sections=${showHourly ? 'hourly' : 'current'}&timezone=auto&language=en&units=auto&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (mounted) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          setState(() {
            if (showHourly) {
              // Si se muestra la vista por horas
              hourlyForecasts =
                  HourlyForecast.parseHourly(data['hourly']['data']);
            } else {
              // Si se muestra la vista actual
              currentTemperature = data['current']['temperature'];
              currentCondition = data['current']['summary'];
            }
          });
        } else {
          print(
              'Error al obtener el clima. Código de estado: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error al obtener el clima: $error');
    }
  }

  Future<void> fetchHourlyWeather() async {
    String apiUrl =
        'https://www.meteosource.com/api/v1/free/point?lat=18.4667N&lon=69.8333W&sections=hourly&timezone=auto&language=en&units=auto&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (mounted) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          setState(() {
            hourlyForecasts =
                HourlyForecast.parseHourly(data['hourly']['data']);
          });
        } else {
          print(
              'Error al obtener el clima por horas. Código de estado: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error al obtener el clima por horas: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Clima en Santo Domingo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (showHourly)
              _buildHourlyForecast()
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Temperatura Actual:',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '${currentTemperature.toStringAsFixed(1)} °C',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Condición Actual:',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '$currentCondition',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showHourly = false; // Mostrar vista actual
                    });
                    fetchWeather(); // Actualizar datos
                  },
                  child: const Text('Actual'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showHourly = true; // Mostrar vista por horas
                    });
                    fetchHourlyWeather(); // Actualizar datos
                  },
                  child: const Text('Por Horas'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Expanded(
      child: ListView(
        children: [
          const Text(
            'Pronóstico por Horas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (hourlyForecasts.isNotEmpty)
            Column(
              children: hourlyForecasts.map((forecast) {
                return ListTile(
                  title: Text(forecast.date),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${forecast.temperature.toStringAsFixed(1)} °C'),
                      Text(forecast.summary),
                    ],
                  ),
                  trailing: Icon(_getWeatherIcon(forecast.icon)),
                );
              }).toList(),
            )
          else
            const Text('No hay datos disponibles'),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(int iconCode) {
    // Lógica para asignar iconos según el código del clima
    // Puedes ajustar esto según la respuesta de la API que estás utilizando
    return Icons.cloud; // Ejemplo: Se usa el ícono de nube por defecto
  }
}

class HourlyForecast {
  final String date;
  final double temperature;
  final String summary;
  final int icon;

  HourlyForecast({
    required this.date,
    required this.temperature,
    required this.summary,
    required this.icon,
  });

  static List<HourlyForecast> parseHourly(List<dynamic> data) {
    return data
        .map(
          (item) => HourlyForecast(
            date: item['date'],
            temperature: item['temperature'].toDouble(),
            summary: item['summary'],
            icon: item['icon'],
          ),
        )
        .toList();
  }
}
