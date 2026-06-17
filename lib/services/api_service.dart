import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/endereco.dart';
import '../models/pokemon.dart';

class ApiService {
  static const int _timeoutSeconds = 10;

  // REQUISIÇÃO 1: ViaCEP
  Future<Endereco> buscarCep(String cep) async {
    final uri = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final endereco = Endereco.fromJson(data);
        if (endereco.erro) {
          throw Exception('CEP não encontrado na base de dados.');
        }
        return endereco;
      } else {
        throw Exception('Erro no servidor (Status: ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('Tempo de conexão esgotado (Timeout). Verifique sua rede.');
    } on SocketException {
      throw Exception('Sem conexão com a internet (SocketException).');
    } catch (e) {
      throw Exception('Ocorreu um erro: $e');
    }
  }

  // REQUISIÇÃO 2: PokeAPI
  Future<Pokemon> buscarPokemon(String nome) async {
    final nomeFormatado = nome.trim().toLowerCase();
    final uri = Uri.parse('https://pokeapi.co/api/v2/pokemon/$nomeFormatado');
    
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Pokemon.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Pokémon não encontrado (Status: 404).');
      } else {
        throw Exception('Erro no servidor (Status: ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('Tempo de conexão esgotado (Timeout). Verifique sua rede.');
    } on SocketException {
      throw Exception('Sem conexão com a internet (SocketException).');
    } catch (e) {
      throw Exception('Ocorreu um erro: $e');
    }
  }
}