import 'package:flutter/material.dart';

class RoleDetailScreen extends StatelessWidget {
  final String title;

  const RoleDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle"),
      ),
      body: Center(
        child: Text(
          "Detalle del rol: $title",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}