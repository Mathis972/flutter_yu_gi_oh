import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/model/cart.dart';
import 'package:http/http.dart' as http;

class CardListWidget extends StatefulWidget {
  const CardListWidget({Key? key}) : super(key: key);

  @override
  State<CardListWidget> createState() => _CardListWidgetState();
}

class _CardListWidgetState extends State<CardListWidget> {
  @override
  final url = "https://db.ygoprodeck.com/api/v7";
  List<cardModel> dataCardList = [];

  Future<void> getCard() async {
    final response = await http.get(Uri.parse("$url/cardinfo.php"));
    final jsonConvert = jsonDecode(response.body);
    List<dynamic> jsonList = jsonConvert['data'];
    for (var element in jsonList) {
      setState(() {
        dataCardList.add(cardModel.fromJson(element));
      });
    }
  }

  Future<void> init() async {
    await getCard();
  }

  void initState() {
    init();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des cartes'),
      ),
      body: Container(
          child: GridView.builder(
        itemCount: dataCardList.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
            },
            child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(dataCardList[index].url),
            )),
          );
        },
      )),
    );
  }
}
