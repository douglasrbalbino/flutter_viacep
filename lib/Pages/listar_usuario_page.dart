import 'package:flutter/material.dart';
import 'package:flutter_application_3/Component/usuario_card.dart';
import 'package:flutter_application_3/Models/usuario_model.dart';
import 'package:flutter_application_3/Services/firebase_service.dart';

class ListarUsuarioPage extends StatefulWidget {
  const ListarUsuarioPage({super.key});

  @override
  State<ListarUsuarioPage> createState() => _ListarUsuarioPageState();
}

class _ListarUsuarioPageState extends State<ListarUsuarioPage> {
  final FirebaseService _firebaseService = FirebaseService(
    collectionName: "usuarios",
  );

  List<Usuario> _usuarios = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    print("Iniciando _fetchUsers...");
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      List<Map<String, dynamic>> userMaps = await _firebaseService.readAll();
      print("Dados recebidos: ${userMaps.length} usuários");
      setState(() {
        _usuarios = userMaps
            .map((map) => Usuario.fromMap(map, map['id']))
            .toList();
        _isLoading = false;
        print("Estado atualizado com sucesso.");
      });
    } catch (erro) {
      print("Erro em _fetchUsers: $erro");
      setState(() {
        _errorMessage = "Erro ao buscar usuários: $erro";
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- Método para exibir o Bottom Sheet Modal ---
  void _showEditModal(Usuario usuario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permite que o modal ocupe mais espaço se necessário
      shape: const RoundedRectangleBorder(
        // Bordas arredondadas
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Conteúdo do Modal
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            // Adiciona padding na parte inferior para evitar o teclado (se houver campos de texto)
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Faz o modal ter a altura do conteúdo
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20, // Define o tamanho do avatar
                      backgroundColor: Colors.blueGrey[100], // Cor de fundo
                      child: Text(
                        // Pega a primeira letra do nome, se não estiver vazio, e a torna maiúscula
                        usuario.nome.isNotEmpty
                            ? usuario.nome[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[700], // Cor da letra
                        ),
                      ),
                    ),
                    Text('Nome: ${usuario.nome}'),
                  ],
                ),
              ),

              Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Color(0xfff5f5f5),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.email),
                          ),
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Email:'), Text(usuario.email)],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    color: Color(0xfff5f5f5),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.phone),
                          ),
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Telefone:'),
                              Text(usuario.telefone),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    color: Color(0xfff5f5f5),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.card_membership),
                          ),
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('CPF:'), Text(usuario.cpf)],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    color: Color(0xfff5f5f5),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.circle),
                          ),
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('ID:'), Text(usuario.id)],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuários Cadastrados")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_usuarios.isEmpty) {
      return const Center(child: Text("Nenhum usuário cadastrado."));
    }

    return ListView.builder(
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        final usuario = _usuarios[index];
        return UsuarioCard(
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
          telefone: usuario.telefone,
          // Passa a função _showEditModal com o usuário atual para o card
          onEditPressed: () =>
              _showEditModal(usuario), // <-- Passe a função aqui
        );
      },
    );
  }
}
