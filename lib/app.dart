import 'package:flutter/material.dart';
import 'package:flutter_application_3/Pages/form_cadastro_usuario_page.dart';
import 'package:flutter_application_3/Pages/home_page.dart';

class ViaCepApi extends StatelessWidget {
  const ViaCepApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FormCadastroUsuarioPage(),
    );
  }
}
