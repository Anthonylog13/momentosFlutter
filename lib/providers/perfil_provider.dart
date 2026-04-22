import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class PerfilProvider  extends ChangeNotifier {
  

Map<String, dynamic> profile = {};
bool isLoading = false;

Future<void> fetchProfil(String id) async {
  isLoading = true;
  notifyListeners();


    try{
    final url = Uri.parse('http://localhost:3001/profiles/$id');
    final response = await http.get(url);
    profile = jsonDecode(response.body);
    } catch(e){
      throw Exception("Error al cargar el perfil: $e");
    }
    isLoading = false;
    notifyListeners();
    
  }



  Future<void> updateProfile(String id, Map<String, String> profile) async {

    try{
      final url = Uri.parse('http://localhost:3001/profiles/$id');
      await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile),
    );
    } catch(e){
      throw Exception("Error al actualizar el perfil: $e");
    }
    await fetchProfil(id);

  }
  }