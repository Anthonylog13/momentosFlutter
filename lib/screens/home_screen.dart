import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/moments_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  Map<int, int> likes = {};

  Future<List<dynamic>>? _futureMoments;

  @override
  void initState() {
    super.initState();
    _futureMoments = fetchMomentos();
  }

  Future<List<dynamic>> fetchMomentos() async {
    final url = Uri.parse('http://localhost:3001/moments');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    return data["momentos"];
  }

  Future<void> createMoment(Map<String, String> moment) async {
    final url = Uri.parse('http://localhost:3001/moments');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(moment),
    );
  }

  Future<void> updateMoment(String id, Map<String, String> moment) async {
    final url = Uri.parse('http://localhost:3001/moments/$id');
    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(moment),
    );
  }

  Future<void> deleteMoment(String id) async {
    final url = Uri.parse('http://localhost:3001/moments/$id');
    await http.delete(url);
  }

  List<Map<String, String>> momentos = [];
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _futureMoments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final momento = data[index];

              return Dismissible(
                key: ValueKey(momento["id"]),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await deleteMoment(momento["id"].toString());
                  setState(() {
                    _futureMoments = fetchMomentos();
                  });
                },
                background: Container(
                  color: const Color.fromARGB(255, 226, 225, 225),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInBack,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: MomentsCard(context, momento, index),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 117, 117, 117),

        child: Icon(Icons.add, color: Colors.white),

        onPressed: () {
          _showBottom(context);
        },
      ),
    );
  }

  Future<void> _editMoment(Map<String, dynamic> momento) async {
    final result = await showModalBottomSheet(
      context: context,

      builder: (contexto) => Container(
        width: MediaQuery.of(context).size.width,

        height: 500,

        color: Colors.white,

        child: MomentsForm(
          initialData: {
            "title": momento["titulo"],
            "descripcion": momento["descripcion"],
            "imagen": momento["imagen"],
          },
        ),
      ),
    );

    if (result != null) {
      await updateMoment(momento["id"].toString(), result);
      setState(() {
        _futureMoments = fetchMomentos();
      });
    }
  }

  Future<void> _showBottom(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,

      builder: (contexto) => Container(
        width: MediaQuery.of(context).size.width,

        height: 500,

        color: Colors.white,

        child: MomentsForm(),
      ),
    );

    if (result != null) {
      await createMoment(result);
      setState(() {
        _futureMoments = fetchMomentos();
      });
    }
  }

  Widget MomentsCard(
    BuildContext context,
    Map<String, dynamic> momento,
    int index,
  ) {
    String titulo = momento["titulo"];
    String descripcion = momento["descripcion"];
    String imagen = momento["imagen"];
    int likesCount = likes[index] ?? 0;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, 
        
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>  MomentsDetail(
            descripcion: descripcion, titulo: titulo, imagen: imagen,),

            transitionsBuilder: (context, animation, secondaryAnimation, child){
              const begin = Offset(1.0, 0.0);

              const end = Offset.zero;

              final tween = Tween(begin: begin, end: end);

              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
                );
            } ,
        ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),

            child: Row(
              children: [
                // Imagen
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.asset(
                    momento["imagen"],

                    width: 120,

                    height: 100,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,

                        height: 100,

                        color: Colors.grey,

                        child: Icon(Icons.error),
                      );
                    },
                  ),
                ),

                SizedBox(width: 12),

                // Texto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(descripcion, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _editMoment(momento);
                      },
                      icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () async {
                        await deleteMoment(momento["id"].toString());
                        setState(() {
                          _futureMoments = fetchMomentos();
                        });
                      },
                      icon: Icon(Icons.delete, size: 20, color: Colors.red),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          likes[index] = (likes[index] ?? 0) + 1;
                        });
                      },
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              Icons.favorite,
                              key: ValueKey<int>(likesCount),
                              color: likesCount > 0 ? Colors.red : Colors.grey,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            likesCount.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MomentsForm extends StatefulWidget {
  final Map<String, String>? initialData;

  const MomentsForm({super.key, this.initialData});

  @override
  State<MomentsForm> createState() => _MomentsFormState();
}

class _MomentsFormState extends State<MomentsForm> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController _momentosTitle;

  late TextEditingController _momentosDescripcion;

  late TextEditingController _momentosURL;

  @override
  void initState() {
    super.initState();

    _momentosTitle = TextEditingController(
      text: widget.initialData?["title"] ?? "",
    );

    _momentosDescripcion = TextEditingController(
      text: widget.initialData?["descripcion"] ?? "",
    );

    _momentosURL = TextEditingController(
      text: widget.initialData?["imagen"] ?? "",
    );
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),

      child: Form(
        key: _formkey,

        child: Column(
          children: [
            Text(
              "Agregar  momento",

              style: TextStyle(color: Colors.amber, fontSize: 24),
            ),

            SizedBox(height: 16),

            buildTextField(
              label: "Nombre Momento",

              controller: _momentosTitle,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingrese un nombre del momento ";
                }

                return null;
              },
            ),
            SizedBox(height: 16),

            buildTextField(
              label: "Descripción Momento",

              controller: _momentosDescripcion,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingrese una descripción del momento ";
                }

                return null;
              },
            ),

            SizedBox(height: 16),

            buildTextField(
              label: "URL imagen",

              controller: _momentosURL,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingrese una imagen del momento ";
                }

                return null;
              },
            ),

            SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    Navigator.pop(context, {
                      "titulo": _momentosTitle.text,
                      "descripcion": _momentosDescripcion.text,

                      "imagen": _momentosURL.text,
                    });
                  }
                },

                child: Text("Guardar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTextField({
  required String label,

  required TextEditingController controller,

  required String? Function(String?) validator,
}) {
  return TextFormField(
    controller: controller,

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
