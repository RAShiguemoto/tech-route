import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_route/app/controller/home_page_controller.dart';
import 'package:tech_route/app/controller/questao_controller.dart';
import 'app/my_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageController()),
        ChangeNotifierProvider(create: (_) => QuestaoController()),
      ],
      child: const MyApp(),
    ),
  );
}
