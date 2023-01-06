import 'package:flutter/material.dart';

class CardListWidget extends StatefulWidget {
  const CardListWidget({Key? key}) : super(key: key);

  @override
  State<CardListWidget> createState() => _CardListWidgetState();
}

class _CardListWidgetState extends State<CardListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des cartes'),
      ),
      body: Text('Liste des sets')
    );
  }
}
