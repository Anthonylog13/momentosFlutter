import 'package:flutter/material.dart';

class MomentsDetail extends StatefulWidget {
  final String descripcion;
  final String titulo;
  final String imagen;

  const MomentsDetail({
    super.key, 
    required this.descripcion, 
    required this.titulo, 
    required this.imagen
  });

  @override
  State<MomentsDetail> createState() => _MomentsDetailState();
}

class _MomentsDetailState extends State<MomentsDetail> {
  bool isExpanded = false;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        elevation: 0,
        title: const Text(
          "Detalle del Momento", 
          style: TextStyle(fontWeight: FontWeight.w600)
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.arrow_back, color: Colors.black87)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.titulo, 
                    style: const TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    )
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(2)
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap:() {
                setState(() {
                  isExpanded = !isExpanded;

                });
              },
              child:  AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: isExpanded ? 400 : 200,
                width: isExpanded ? MediaQuery.of(context).size.width : 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imagen, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("No se pudo cargar la imagen", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                widget.descripcion, 
                style: const TextStyle(
                  fontSize: 16, 
                  height: 1.5,
                  color: Colors.black87
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}