import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3/Models/endereco.dart';
import 'package:flutter_application_3/Services/connectivity_service.dart';
import 'package:flutter_application_3/Services/via_cep_services.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  // Variáveis de estado (Etapa 3.1)
  bool _temInternet = true;
  bool _buscando = false;
  Endereco? _enderecoEncontrado;
  String? _mensagemErro;
  List<String> _historico = [];
  bool _veioDoCache = false; // Controla o badge "Online" ou "Cache"

  // Serviços e Controllers (Etapa 3.2)
  final ConnectivityService _connectivityService = ConnectivityService();
  final ViaCepServices _viaCepService = ViaCepServices();
  final TextEditingController _cepController = TextEditingController();
  StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    // Etapa 3.3 - Inicialização
    _connectivityService.initialize();
    _verificarConexaoInicial();
    _ouvirMudancasDeConexao();
    _carregarHistorico();
  }

  // Verifica a conexão assim que a tela abre
  Future<void> _verificarConexaoInicial() async {
    bool isConnected = await _connectivityService.checkconnectivity();
    setState(() {
      _temInternet = isConnected;
    });
  }

  // Ouve mudanças na conexão (Ex: usuário liga/desliga o WiFi)
  void _ouvirMudancasDeConexao() {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((status) {
      setState(() {
        _temInternet = status;
        if (status) {
          _mensagemErro = null; // Limpa erros de "sem internet"
        }
      });
    });
  }

  // Carrega a lista de CEPs salvos no CacheService
  Future<void> _carregarHistorico() async {
    try {
      final ceps = await _viaCepService.obterHistorico();
      setState(() {
        _historico = ceps;
      });
    } catch (e) {
      // Tratar erro ao carregar histórico, se necessário
    }
  }

  // Limpa o cache e atualiza a UI
  Future<void> _limparHistorico() async {
    await _viaCepService.limparHistorico();
    _carregarHistorico(); // Recarrega a lista (agora vazia)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Histórico limpo com sucesso!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Método principal de busca (Etapa 3.4)
  Future<void> _buscarCep(String cep) async {
    // Limpa resultados anteriores
    setState(() {
      _buscando = true;
      _enderecoEncontrado = null;
      _mensagemErro = null;
      _veioDoCache = false;
    });

    try {
      // Verifica a conexão ANTES de tentar buscar
      final temConexao = await _connectivityService.checkconnectivity();
      setState(() {
        _temInternet = temConexao;
      });

      // Chama o serviço que já tem a lógica de cache/api
      final endereco = await _viaCepService.buscarEndereco(cep);

      if (endereco != null) {
        setState(() {
          _enderecoEncontrado = endereco;
          // Se não tínhamos internet, sabemos que veio do cache
          _veioDoCache = !temConexao;
        });

        // Atualiza o histórico na UI
        if (!_historico.contains(cep)) {
          _carregarHistorico();
        }
      } else {
        setState(() {
          _mensagemErro = "CEP não encontrado na base de dados (ViaCEP).";
        });
      }
    } catch (e) {
      // Captura a exceção (ex: offline e sem cache)
      setState(() {
        _mensagemErro = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _buscando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Etapa 3.5 - Construção da Interface
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de CEP"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // (Etapa 3.5.A) Indicador de Conexão
          _buildStatusIcon(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // (Etapa 3.5.B) Banner Offline
            if (!_temInternet) _buildOfflineBanner(),
            const SizedBox(height: 16),
            // (Etapa 3.5.C) Campo de CEP
            _buildCepInputField(),
            const SizedBox(height: 16),
            // (Etapa 3.5.D) Botão de Buscar
            _buildSearchButton(),
            const SizedBox(height: 20),
            // (Etapa 3.5.E) Mensagem de Erro
            if (_mensagemErro != null) _buildErrorMessage(),
            // (Etapa 3.5.F) Card de Resultado
            if (_enderecoEncontrado != null)
              _buildResultCard(_enderecoEncontrado!),
            const SizedBox(height: 20),
            // (Etapa 3.5.G) Seção de Histórico
            if (_historico.isNotEmpty) _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  // (Etapa 3.5.A)
  Widget _buildStatusIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Icon(
            _temInternet ? Icons.wifi : Icons.wifi_off,
            color: _temInternet ? Colors.white : Colors.red[300],
          ),
          const SizedBox(width: 8),
          Text(
            _temInternet ? "Online" : "Offline",
            style: TextStyle(
              color: _temInternet ? Colors.white : Colors.red[300],
            ),
          ),
        ],
      ),
    );
  }

  // (Etapa 3.5.B)
  Widget _buildOfflineBanner() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Você está offline. Apenas CEPs já consultados podem ser buscados no cache.",
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // (Etapa 3.5.C)
  Widget _buildCepInputField() {
    return TextField(
      controller: _cepController,
      decoration: InputDecoration(
        labelText: "Digite o CEP",
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          // Ícone de cache quando offline
          !_temInternet ? Icons.storage : Icons.search,
        ),
        suffixIcon: _cepController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _cepController.clear();
                  setState(() {
                    _enderecoEncontrado = null;
                    _mensagemErro = null;
                  });
                },
              )
            : null,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
    );
  }

  // (Etapa 3.5.D)
  Widget _buildSearchButton() {
    return ElevatedButton.icon(
      icon: _buscando
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.search, color: Colors.white),
      label: Text(
        _buscando ? "Buscando..." : "Buscar CEP",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // Desabilita o botão se estiver buscando ou se o CEP for inválido
      onPressed: _buscando || _cepController.text.length < 8
          ? null
          : () {
              _buscarCep(_cepController.text);
              // Esconde o teclado
              FocusScope.of(context).unfocus();
            },
    );
  }

  // (Etapa 3.5.E)
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _mensagemErro!,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // (Etapa 3.5.F)
  Widget _buildResultCard(Endereco endereco) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Endereço Encontrado",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                // Badge "Online" ou "Cache"
                Chip(
                  label: Text(_veioDoCache ? "CACHE" : "ONLINE"),
                  labelStyle: TextStyle(
                    color: _veioDoCache ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: _veioDoCache
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                  side: BorderSide(
                    color: _veioDoCache ? Colors.orange : Colors.green,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildResultRow("CEP:", endereco.cep ?? "-"),
            _buildResultRow("Logradouro:", endereco.logradouro ?? "-"),
            _buildResultRow("Bairro:", endereco.bairro ?? "-"),
            _buildResultRow("Cidade:", endereco.localidade ?? "-"),
            _buildResultRow("Estado:", endereco.uf ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // (Etapa 3.5.G)
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Histórico de Consultas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: _limparHistorico,
              child: const Text("Limpar", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _historico
              .map(
                (cep) => ActionChip(
                  label: Text(cep),
                  onPressed: () {
                    _cepController.text = cep;
                    _buscarCep(cep);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Etapa 3.6 - Limpeza
    _cepController.dispose();
    _connectivitySubscription?.cancel(); // Cancela o "ouvinte"
    _connectivityService.dispose();
    super.dispose();
  }
}