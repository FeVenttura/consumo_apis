import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CepScreen extends StatefulWidget {
  const CepScreen({super.key});

  @override
  State<CepScreen> createState() => _CepScreenState();
}

class _CepScreenState extends State<CepScreen> {
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  final _apiService = ApiService();
  
  bool _isLoading = false;

  void _buscarCep() async {
    final cep = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('O CEP deve conter 8 números.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final endereco = await _apiService.buscarCep(cep);
      if (!mounted) return;
      setState(() {
        _logradouroController.text = endereco.logradouro;
        _cidadeController.text = endereco.localidade;
        _ufController.text = endereco.uf;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()), 
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
      _logradouroController.clear();
      _cidadeController.clear();
      _ufController.clear();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ViaCEP', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cepController,
              decoration: const InputDecoration(
                labelText: 'Digite o CEP',
                prefixIcon: Icon(Icons.markunread_mailbox_rounded),
              ),
              keyboardType: TextInputType.number,
              maxLength: 8,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator()) 
                  : FilledButton.icon(
                      onPressed: _buscarCep, 
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar Endereço', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _logradouroController, 
                      decoration: const InputDecoration(labelText: 'Logradouro', fillColor: Colors.transparent), 
                      readOnly: true
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _cidadeController, 
                      decoration: const InputDecoration(labelText: 'Cidade', fillColor: Colors.transparent), 
                      readOnly: true
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ufController, 
                      decoration: const InputDecoration(labelText: 'UF', fillColor: Colors.transparent), 
                      readOnly: true
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}