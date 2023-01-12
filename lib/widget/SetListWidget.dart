import 'package:flutter/material.dart';

class SetListWidget extends StatefulWidget {
  const SetListWidget({super.key});

  @override
  _SetListWidgetState createState() => _SetListWidgetState();
}

class _SetListWidgetState extends State<SetListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Liste des sets'),
      ),
      body: Text('ListCarte'),
    );
  }
}