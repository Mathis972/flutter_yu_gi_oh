import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/model/cart.dart';
import 'package:flutter_yu_gi_oh/widget/cardDetailsWidget.dart';
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
  List urlCardType = ["assets/Symbol/trap.png", "assets/Symbol/spell.png"];
  TextEditingController nameController = TextEditingController();
  var name = '';

  Future<void> getRandomCard() async {
    final response = await http.get(Uri.parse(url + "/randomcard.php"));
    if (response.statusCode == 200) {
      dataCardList.clear();
      final jsonConvert = jsonDecode(response.body);
      final card = cardModel.fromJson(jsonConvert);
      setState(() {
        dataCardList.add(card);
      });
    }
  }

  Future<void> getCard() async {
    final response = await http.get(Uri.parse("$url/cardinfo.php?language=fr"));
    print(response.statusCode);
    if (response.statusCode == 400) {
      dataCardList = [];
    }
    if (response.statusCode == 200) {
      final jsonConvert = jsonDecode(response.body);
      List<dynamic> jsonList = jsonConvert['data'];
      for (var element in jsonList) {
        setState(() {
          dataCardList.add(cardModel.fromJson(element));
        });
      }
    }
  }

  Future<void> refresh() async {
    setState(() {
      dataCardList = [];
    });
    await getCard();
  }

  Future<void> getCardByName() async {
    final response =
        await http.get(Uri.parse("$url/cardinfo.php?language=fr&fname=$name"));
    if (response.statusCode == 400) {
      dataCardList = [];
    }
    if (response.statusCode == 200) {
      final jsonConvert = jsonDecode(response.body);
      List<dynamic> jsonList = jsonConvert['data'];
      dataCardList.clear();
      for (var element in jsonList) {
        setState(() {
          dataCardList.add(cardModel.fromJson(element));
        });
      }
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onEditingComplete: () {
                    setState(() {
                      name = nameController.text;
                    });
                    getCardByName();
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          name = '';
                          nameController.text = '';
                        });
                        getCardByName();
                      },
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                    fillColor: Colors.blueGrey,
                    hintText: 'Rechercher',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: nameController,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    name = '';
                    nameController.text = '';
                  });
                  getRandomCard();
                },
                icon: Icon(Icons.casino_outlined, color: Colors.black),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: dataCardList != null
                ? GridView.builder(
                    itemCount: dataCardList.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.6,
                      crossAxisCount: 6,
                      crossAxisSpacing: 0.5,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CardDetailsWidget(
                              card: dataCardList[index],
                            ),
                          ));
                        },
                        child: Stack(
                          children: [
                            Container(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 2.0, left: 2.0),
                              child: Image.network(
                                  width: 300, dataCardList[index].url),
                            )),
                            ClipRRect(
                                borderRadius: new BorderRadius.circular(60.0),
                                child: dataCardList[index].type == "Spell Card"
                                    ? Image.asset(
                                        height: 20,
                                        width: 20,
                                        "assets/Symbol/spell.png")
                                    : dataCardList[index].type == "Trap Card"
                                        ? Image.asset(
                                            height: 20,
                                            width: 20,
                                            "assets/Symbol/trap.png")
                                        : dataCardList[index]
                                                .type
                                                .contains('Monster')
                                            ? dataCardList[index].attribute ==
                                                    "WATER"
                                                ? Image.asset(
                                                    height: 20,
                                                    width: 20,
                                                    "assets/Symbol/water.png")
                                                : dataCardList[index]
                                                            .attribute ==
                                                        "EARTH"
                                                    ? Image.asset(
                                                        height: 20,
                                                        width: 20,
                                                        "assets/Symbol/earth.png")
                                                    : dataCardList[index]
                                                                .attribute ==
                                                            "FIRE"
                                                        ? Image.asset(
                                                            height: 20,
                                                            width: 20,
                                                            "assets/Symbol/fire.png")
                                                        : dataCardList[index]
                                                                    .attribute ==
                                                                "DARK"
                                                            ? Image.asset(
                                                                height: 20,
                                                                width: 20,
                                                                "assets/Symbol/dark.png")
                                                            : dataCardList[index]
                                                                        .attribute ==
                                                                    "LIGHT"
                                                                ? Image.asset(
                                                                    height: 20,
                                                                    width: 20,
                                                                    "assets/Symbol/light.png")
                                                                : dataCardList[index]
                                                                            .attribute ==
                                                                        "WIND"
                                                                    ? Image.asset(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        "assets/Symbol/wind.png")
                                                                    : Container()
                                            : Container()),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 75.0, left: 10.0),
                              child: dataCardList[index].level != null
                                  ? Row(
                                      children: [
                                        Text(
                                          "${dataCardList[index].level.toString()} X",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ClipRRect(
                                            borderRadius:
                                                new BorderRadius.circular(60.0),
                                            child: Image.asset(
                                                "assets/stars/star.png",
                                                height: 20,
                                                width: 20)),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
