// import 'package:api_consumo/Pages/mapa_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/Pages/home_page.dart';

class ViaCepApi extends StatelessWidget {
  const ViaCepApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACO ACO ACO ACO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA7C957)),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}