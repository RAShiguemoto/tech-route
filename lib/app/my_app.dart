import 'package:flutter/material.dart';
import 'package:tech_route/app/pages/praticas_page.dart';
import 'package:tech_route/app/pages/questao_page.dart';
import 'package:tech_route/app/pages/resposta_page.dart';

import 'pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Route',
      theme: ThemeData(
          primaryColor: Colors.amber[600],
          scaffoldBackgroundColor: const Color.fromARGB(255, 15, 16, 17)),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        'praticas': (context) => const PraticasPage(),
        'questoes': (context) => const QuestaoPage(),
        'resposta': (context) => const RespostaPage(),
      },
    );
  }
}
