import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Para garantir que todos os widgets do flutter sejam iniciados antes do firebase
  await Firebase.initializeApp(); // Para inicializar o firebase

  runApp(const ViaCepApi());
}
