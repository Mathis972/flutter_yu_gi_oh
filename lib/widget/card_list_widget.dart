import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/model/cart.dart';
import 'package:flutter_yu_gi_oh/widget/card_details_widget.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardListWidget extends StatefulWidget {
  const CardListWidget({Key? key}) : super(key: key);

  @override
  State<CardListWidget> createState() => _CardListWidgetState();
}

class _CardListWidgetState extends State<CardListWidget> {
  final url = "https://db.ygoprodeck.com/api/v7";
  List<CardModel> dataCardList = [];
  List<String> favList = [];
  int displayAnim = 0;
  List urlCardType = ["assets/Symbol/trap.png", "assets/Symbol/spell.png"];
  TextEditingController nameController = TextEditingController();
  String name = '';
  bool isLoad = false;

  Future<void> getRandomCard() async {
    final response = await http.get(Uri.parse("$url/randomcard.php"));
    if (response.statusCode == 200) {
      dataCardList.clear();
      final jsonConvert = jsonDecode(response.body);
      final card = CardModel.fromJson(jsonConvert);
      setState(() {
        dataCardList.add(card);
      });
    }
  }

  Future<void> getFavList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? idList = prefs.getStringList('favs');
    if (idList != null) {
      setState(() {
        favList = idList;
      });
    }
  }

  Future<void> getCard() async {
    final response = await http.get(Uri.parse("$url/cardinfo.php?language=fr"));
    if (response.statusCode == 400) {
      dataCardList = [];
    }
    if (response.statusCode == 200) {
      final jsonConvert = jsonDecode(response.body);
      List<dynamic> jsonList = jsonConvert['data'];
      for (var element in jsonList) {
        setState(() {
          dataCardList.add(CardModel.fromJson(element));
        });
      }
      setState(() {
        isLoad = true;
      });
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
          dataCardList.add(CardModel.fromJson(element));
        });
      }
    }
  }

  Future<void> init() async {
    await getCard();
    await getFavList();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des cartes'),
      ),
      body: isLoad
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 8.0, top: 8.0),
                          child: TextField(
                            onEditingComplete: () {
                              setState(() {
                                name = nameController.text;
                              });
                              getCardByName();
                            },
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.white),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    name = '';
                                    nameController.clear();
                                  });
                                  getCardByName();
                                },
                                icon: const Icon(Icons.close, color: Colors.white),
                              ),
                              fillColor: Colors.blueGrey,
                              hintText: 'Rechercher',
                              hintStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            controller: nameController,
                          ),
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
                        icon: const Icon(Icons.casino_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child:
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              itemCount: dataCardList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.6,
                                crossAxisCount: 6,
                                crossAxisSpacing: 0.5,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onDoubleTap: () async {
                                    Timer(
                                        const Duration(seconds: 1),
                                        () => {
                                              setState(() {
                                                displayAnim = 0;
                                              }),
                                            });
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    bool cardInList = false;
                                    if (favList.isNotEmpty) {
                                      cardInList = favList.contains(
                                          dataCardList[index].id.toString());
                                      if (!cardInList) {
                                        favList.add(
                                            dataCardList[index].id.toString());
                                        setState(() {
                                          displayAnim = dataCardList[index].id;
                                        });
                                      } else {
                                        favList.remove(
                                            dataCardList[index].id.toString());
                                      }
                                    } else {
                                      favList.add(
                                          dataCardList[index].id.toString());
                                      setState(() {
                                        displayAnim = dataCardList[index].id;
                                      });
                                    }
                                    await prefs.setStringList('favs', favList);
                                    setState(() {
                                      favList = favList;
                                    });
                                  },
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => CardDetailsWidget(
                                        card: dataCardList[index],
                                      ),
                                    ));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                          color: favList.contains(
                                                  dataCardList[index]
                                                      .id
                                                      .toString())
                                              ? Colors.red
                                              : Colors.transparent,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 2.0, left: 2.0),
                                            child: Image.network(
                                                width: 300,
                                                dataCardList[index].url),
                                          )),
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          child: dataCardList[index].type ==
                                                  "Spell Card"
                                              ? Image.asset(
                                                  height: 20,
                                                  width: 20,
                                                  "assets/Symbol/spell.png")
                                              : dataCardList[index].type ==
                                                      "Trap Card"
                                                  ? Image.asset(
                                                      height: 20,
                                                      width: 20,
                                                      "assets/Symbol/trap.png")
                                                  : dataCardList[index]
                                                          .type
                                                          .contains('Monster')
                                                      ? dataCardList[index].attribute == "WATER"
                                                          ? Image.asset(height: 20, width: 20, "assets/Symbol/water.png")
                                                          : dataCardList[index].attribute == "EARTH"
                                                              ? Image.asset(height: 20, width: 20, "assets/Symbol/earth.png")
                                                              : dataCardList[index].attribute == "FIRE"
                                                                  ? Image.asset(height: 20, width: 20, "assets/Symbol/fire.png")
                                                                  : dataCardList[index].attribute == "DARK"
                                                                      ? Image.asset(height: 20, width: 20, "assets/Symbol/dark.png")
                                                                      : dataCardList[index].attribute == "LIGHT"
                                                                          ? Image.asset(height: 20, width: 20, "assets/Symbol/light.png")
                                                                          : dataCardList[index].attribute == "WIND"
                                                                              ? Image.asset(height: 20, width: 20, "assets/Symbol/wind.png")
                                                                              : Container()
                                                      : Container()),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 70.0, left: 10.0),
                                        child: dataCardList[index].level != null
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "${dataCardList[index].level.toString()} X",
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(60.0),
                                                      child: Image.asset(
                                                          "assets/stars/star.png",
                                                          height: 20,
                                                          width: 20)),
                                                ],
                                              )
                                            : Container(),
                                      ),
                                      if (displayAnim != 0 &&
                                          displayAnim == dataCardList[index].id)
                                        LottieBuilder.network(
                                            'https://assets10.lottiefiles.com/datafiles/hvAaKBDVLhuV5Wl/data.json'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                  ),
                ],
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(child: CircularProgressIndicator())),
    );
  }
}
