import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/perfil_provider.dart';
import '../services/notifications_services.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _isLoading = false;
  bool _isEditing = false;



  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PerfilProvider>().fetchProfil("1");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PerfilProvider>();
    
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final profile = provider.profile;
        if (!_isLoading && profile.isNotEmpty) {
          _nameController.text = profile['nombre'] ?? '';
          _emailController.text = profile['correo'] ?? '';
          _edadController.text = profile['edad'] ?? '';
          _celularController.text = profile['celular'] ?? '';

          _isLoading = true;
        }
        return buildProfileUi(profile);
      }
   
  
    Widget buildProfileUi(Map<String, dynamic> profile) {
      return
  

    SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.amberAccent,
                      child: Icon(Icons.person, size: 35, color: Colors.white),
                    ),
                    SizedBox(height: 16),

                    Text(
                      "Perfil",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),

                    buildTextField(
                      enabled: _isEditing,
                      label: "Nombre",
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingrese su nombre";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    buildTextField(
                      enabled: _isEditing,
                      label: "Correo electrónico",
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingrese su correo electrónico";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    buildTextField(
                      enabled: _isEditing,
                      label: "Edad",
                      controller: _edadController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingrese su edad";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    buildTextField(
                      enabled: _isEditing,
                      label: "Celular",
                      controller: _celularController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingrese su número de celular";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    ElevatedButton(
                    onPressed: () async {
                      if (_isEditing) {
                    
                        await context.read<PerfilProvider>().updateProfile("1", {
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "edad": _edadController.text,
                          "celular": _celularController.text,
                        });

                      
                        setState(() {
                          _isLoading = false;
                        });
                      }

                     
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isEditing ? "Guardar" : "Editar"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await NotificationsService.showNotification();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isEditing ? "Guardar" : "Editar"),
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,

    required TextEditingController controller,

    required String? Function(String?) validator,
    required bool enabled,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,

      decoration: InputDecoration(
        labelText: label,

        labelStyle: TextStyle(color: Colors.orange),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),

          borderSide: BorderSide(color: Colors.orange, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),

          borderSide: BorderSide(color: Colors.orange, width: 1.5),
        ),
      ),
    );
  }
}
