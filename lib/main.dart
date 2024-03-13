// ignore_for_file: prefer_const_constructors, unnecessary_late, prefer_final_fields

/*
Nombre: Edward Jose Frias Castro
Matricula: 2021-1447
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tarea6/controllers/AgeResult.dart';
import 'package:tarea6/controllers/Contratarme.dart';
import 'package:tarea6/controllers/Home.dart';
import 'package:tarea6/controllers/University.dart';
import 'package:tarea6/controllers/WordPress.dart';
import 'package:tarea6/controllers/gender.dart';
import 'package:tarea6/controllers/weather.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent,
    ),
  );
  runApp(const MyInicioApp());
}

class MyInicioApp extends StatelessWidget {
  const MyInicioApp({super.key});

  static const appTitle = 'Tarea: 6 (Couteau)🎬📱';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyInicioPage(title: appTitle),
    );
  }
}

class MyInicioPage extends StatefulWidget {
  const MyInicioPage({super.key, required this.title});

  final String title;

  @override
  State<MyInicioPage> createState() => _MyInicioPage();
}

class _MyInicioPage extends State<MyInicioPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  static List<Widget> _widgetOptions = [
    HomeView(),
    GenderView(),
    AgeView(),
    UniversityView(),
    WeatherView(),
    WordPressView(),
    ContratarmeView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        itemCount: _widgetOptions.length,
        itemBuilder: (context, index) {
          return Center(child: _widgetOptions[index]);
        },
      ),
      drawer: _buildDrawer(),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: _buildDrawerItems(),
      ),
    );
  }

  List<Widget> _buildDrawerItems() {
    return [
      const DrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 44, 18, 162),
              Color.fromARGB(255, 168, 8, 231),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/img/photo_3.jpg'),
              radius: 45.0,
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nombre: Jose Trinidad',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Matricula: 2022-0575',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      _buildListTile(0, Icons.home, 'Home'),
      _buildListTile(1, Icons.supervised_user_circle, 'Genero'),
      _buildListTile(2, Icons.mood_sharp, 'Determinar edad por nombre'),
      _buildListTile(3, Icons.school, 'Universidad'),
      _buildListTile(4, Icons.cloud_circle, 'Clima'),
      _buildListTile(5, Icons.wordpress, 'Noticias en WordPress'),
      _buildListTile(6, Icons.contact_phone_sharp, 'Contrátame'),
    ];
  }

  ListTile _buildListTile(int index, IconData icon, String title) {
    return ListTile(
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
      title: Row(
        children: [
          Icon(icon, color: _selectedIndex == index ? Colors.blue : null),
          const SizedBox(width: 8.0),
          Text(title),
        ],
      ),
      selected: _selectedIndex == index,
    );
  }
}
