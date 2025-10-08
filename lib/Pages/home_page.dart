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
  bool isLoading = false;

  ViaCepServices viaCepServices = ViaCepServices();

  Future<void> buscarCep(String Cep) async {
    clearController();
    setState(() {
      isLoading = true;
    });
    try {
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
        controllerCep.clear();
        return;
      }

      setState(() {
        endereco = response;
      });

      setControllersCep(endereco!);
    } catch (erro) {
      throw Exception("Erro ao buscar CEP: $erro");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setControllersCep(Endereco endereco) {
    controllerLogradouro.text = endereco.logradouro!;
    controllerComplemento.text = endereco.complemento!;
    controllerBairro.text = endereco.bairro!;
    controllerCidade.text = endereco.localidade!;
    controllerEstado.text = endereco.estado!;
  }

  void clearController() {
    controllerBairro.clear();
    controllerComplemento.clear();
    controllerCidade.clear();
    controllerLogradouro.clear();
    controllerEstado.clear();
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
                onChanged: (valor) {
                  if (valor.isEmpty) {
                    setState(() {
                      endereco = null;
                    });
                    clearController();
                  }
                },
                controller: controllerCep,
                maxLength: 8,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  suffixIcon: isLoading
                      ? SizedBox(
                          width: 10,
                          height: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              15.0,
                            ), // Ao adicionar o padding, o icone de loading se adaptou dentro do pai
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : IconButton(
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

            if (endereco?.bairro != null)
              Column(
                spacing: 10,
                children: [
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
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 5,
                          ),
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
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 5,
                          ),
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
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 5,
                          ),
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
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 5,
                          ),
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
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 5,
                          ),
                        ),
                        labelText: "Estado",
                        labelStyle: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),

            ElevatedButton(onPressed: () {}, child: Text("Buscar")),
          ],
        ),
      ),
    );
  }
}
