import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:flutter_application_2/screens/perfil_screen.dart';
import 'package:provider/provider.dart';
import 'providers/perfil_provider.dart';
void main() {
  runApp(
 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PerfilProvider()),
      
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title:'Hola mundo',debugShowCheckedModeBanner: false ,home:  LibroMomentos(),);
    
  }
}

class LibroMomentos extends StatelessWidget {
  const LibroMomentos({super.key});


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: Text('Libro de Momentos', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.amberAccent,
      bottom: TabBar(tabs:[
        Tab(icon: Icon(Icons.home, color: Colors.white,), text: "home",),
        Tab(icon: Icon(Icons.person_2, color: Colors.white,), text: "Perfil",),
      ]
      ),
    ),
        body: TabBarView(
          children: [
            HomeScreen(), PerfilScreen()],),
    ),
    ) ;

  }
}