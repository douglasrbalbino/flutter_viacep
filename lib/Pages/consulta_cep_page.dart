import 'package:flutter/material.dart';
import 'package:flutter_application_3/Models/endereco.dart';
import 'package:flutter_application_3/Services/connectivity_service.dart';
import 'package:flutter_application_3/Services/via_cep_services.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  bool _temInternet = true;
  bool _buscando = false;
  Endereco? _enderecoEncontrado;
  String? _mensagemErro;
  List<String> _historico = [];
  bool _veioDoCache = false;

  final ConnectivityService _connectivityService = ConnectivityService();
  final ViaCepServices _viaCepService = ViaCepServices();
  final TextEditingController _cepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectivityService.initialize();
    _ouvirMudancasDeConexao();
    _verificarConexaoInicial();
    _carregarHistorico();
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
