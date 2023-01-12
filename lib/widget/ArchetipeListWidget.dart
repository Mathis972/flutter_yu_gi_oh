import 'package:flutter/material.dart';

class ArchetipeListWidget extends StatefulWidget {
  const ArchetipeListWidget({Key? key}) : super(key: key);

  @override
  State<ArchetipeListWidget> createState() => _ArchetipeListWidgetState();
}

class _ArchetipeListWidgetState extends State<ArchetipeListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des archétypes'),
      ),
      body: Text('Liste des archétypes'),
    );
  }
}
