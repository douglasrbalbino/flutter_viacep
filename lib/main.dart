import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/Pages/tela_consulta_cep.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A inicialização do Firebase é mantida, embora não seja usada nesta tela
  // Pode ser útil para outras partes do app
  await Firebase.initializeApp();

  // Envolve a ConsultaCepPage em um MaterialApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de CEP', // (Etapa 4.1)
      theme: ThemeData(
        // (Etapa 4.1)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const ConsultaCepPage(), // (Etapa 4.1)
      debugShowCheckedModeBanner: false,
    );
  }
}
