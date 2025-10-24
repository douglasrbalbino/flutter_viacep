import 'package:flutter/material.dart';
import 'package:flutter_application_3/Models/usuario_model.dart';
import 'package:flutter_application_3/Services/firebase_service.dart';

class ListarUsuarioPage extends StatefulWidget {
  const ListarUsuarioPage({super.key});

  @override
  State<ListarUsuarioPage> createState() => _ListarUsuarioPageState();
}

class _ListarUsuarioPageState extends State<ListarUsuarioPage> {
  final FirebaseService _firebaseService = FirebaseService(
    collectionName: "usuario",
  );

  late Future<List<Usuario>> _futureUsuario;

  @override
  void initState() {
    super.initState();

    _futureUsuario = _fetchUsers();
  }

  Future<List<Usuario>> _fetchUsers() async {
    try {
      List<Map<String, dynamic>> userMaps = await _firebaseService.readAll();
      return userMaps.map((map) => Usuario.fromMap(map, map['id'])).toList();
    } catch (erro) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao buscar usuários: $erro"),
          backgroundColor: Colors.red,
        ),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usuários")),
      body: Column(children: []),
    );
  }
}
