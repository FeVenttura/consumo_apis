import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pokemon.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _nomeController = TextEditingController();
  final _apiService = ApiService();
  Pokemon? _pokemon;
  bool _isLoading = false;

  void _buscarPokemon() async {
    if (_nomeController.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _pokemon = null;
    });

    try {
      final resultado = await _apiService.buscarPokemon(_nomeController.text);
      if (!mounted) return;
      setState(() => _pokemon = resultado);
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PokeAPI', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Pokémon (ex: pikachu)',
                prefixIcon: Icon(Icons.catching_pokemon),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator()) 
                  : FilledButton.icon(
                      onPressed: _buscarPokemon, 
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar Pokémon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
            ),
            const SizedBox(height: 32),
            if (_pokemon != null)
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(_pokemon!.imagemUrl, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _pokemon!.nome.toUpperCase(), 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatChip(context, 'Altura', '${_pokemon!.altura}'),
                          _buildStatChip(context, 'Peso', '${_pokemon!.peso}'),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}