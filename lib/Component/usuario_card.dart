import 'package:flutter/material.dart';

class UsuarioCard extends StatelessWidget {
  final String nome;
  final String email;
  final String telefone;

  const UsuarioCard({
    super.key,
    required this.nome,
    required this.email,
    required this.telefone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Row(
          children: [
            Icon(Icons.person),
            Column(
              children: [
                Text("Nome usuario"),
                Row(children: [Icon(Icons.email), Text("Nomeusuário")]),
                Row(children: [Icon(Icons.phone), Text("Telefone do usuario")]),
                Icon(Icons.download_for_offline_sharp),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
