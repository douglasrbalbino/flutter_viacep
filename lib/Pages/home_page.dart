import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3/Models/endereco.dart';
import 'package:flutter_application_3/Services/via_cep_services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controllerCep = TextEditingController();
  TextEditingController controllerLogradouro = TextEditingController();
  TextEditingController controllerComplemento = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerCidade = TextEditingController();
  TextEditingController controllerEstado = TextEditingController();
  Endereco? endereco; // Variável podereceber null

  ViaCepServices viaCepServices = ViaCepServices();

  Future<void> buscarCep(String Cep) async {
    Endereco? response = await viaCepServices.buscarEndereco(Cep);

    if (response?.localidade == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.warning),
            title: Text("Atenção"),
            content: Text("CEP não encontrado."),
          );
        },
      );
      return;
    }

    setState(() {
      endereco = response;
    });

    setControllersCep(endereco!);
  }

  void setControllersCep(Endereco endereco) {
    controllerLogradouro.text = endereco.logradouro!;
    controllerComplemento.text = endereco.complemento!;
    controllerBairro.text = endereco.bairro!;
    controllerCidade.text = endereco.localidade!;
    controllerEstado.text = endereco.estado!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 200, color: Colors.orange),
            SizedBox(
              width: 300,
              child: TextField(
                controller: controllerCep,
                maxLength: 8,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      buscarCep(controllerCep.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 5),
                  ),
                  labelText: "CEP",
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
            ),

            SizedBox(
              width: 300,
              child: TextField(
                controller: controllerLogradouro,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 5),
                  ),
                  labelText: "Logradouro",
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
            ),

            SizedBox(
              width: 300,
              child: TextField(
                controller: controllerComplemento,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 5),
                  ),
                  labelText: "Complemento",
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
            ),

            SizedBox(
              width: 300,
              child: TextField(
                controller: controllerBairro,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 5),
                  ),
                  labelText: "Bairro",
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
            ),

            SizedBox(
              width: 300,
              child: TextField(
                controller: controllerCidade,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 5),
                  ),
                  labelText: "Cidade",
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
            ),

            SizedBox(
              width: 300,
              child: TextField(
                controller: controllerEstado,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 5),
                  ),
                  labelText: "Estado",
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
            ),

            ElevatedButton(onPressed: () {}, child: Text("Buscar")),
          ],
        ),
      ),
    );
  }
}
