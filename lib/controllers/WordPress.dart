// Ignore warnings for demo purposes
// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class WordPressView extends StatelessWidget {
  const WordPressView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WordPress(),
    );
  }
}

class WordPress extends StatefulWidget {
  const WordPress({super.key});

  @override
  _WordPressViewState createState() => _WordPressViewState();
}

class _WordPressViewState extends State<WordPress> {
  final String apiUrl =
      'https://noticiassin.com/wp-json/wp/v2/posts?per_page=3';

  late List<NewsItem> newsItems;

  @override
  void initState() {
    super.initState();
    newsItems = [];
    fetchData();
  }

  
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        newsItems = data.map((item) => NewsItem.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPress Noticias'),
      ),
      body: newsItems.isNotEmpty
          ? ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                return NewsCard(newsItems[index]);
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class NewsItem {
  final String title;
  final String summary;
  final String link;

  NewsItem({
    required this.title,
    required this.summary,
    required this.link,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    // Elimina las etiquetas HTML del resumen
    final cleanedSummary = _cleanHtmlTags(json['excerpt']['rendered']);

    return NewsItem(
      title: json['title']['rendered'],
      summary: cleanedSummary,
      link: json['link'],
    );
  }

  static String _cleanHtmlTags(String htmlText) {
    // Utiliza una expresión regular para eliminar las etiquetas HTML
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}

class NewsCard extends StatelessWidget {
  final NewsItem newsItem;

  const NewsCard(this.newsItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          launchUrl(Uri.parse(newsItem.link));
        },
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color.fromARGB(162, 119, 91, 188)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  newsItem.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  newsItem.summary,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16.0,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Leer más',
                  style: TextStyle(
                    color: Color.fromARGB(255, 60, 6, 237),
                    fontWeight: FontWeight.bold,
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
