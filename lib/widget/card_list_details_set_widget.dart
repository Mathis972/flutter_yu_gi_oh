import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/model/cart.dart';
import 'package:flutter_yu_gi_oh/widget/card_details_widget.dart';
import 'package:http/http.dart' as http;

class CardListDetailsSetWidget extends StatefulWidget {
  const CardListDetailsSetWidget({Key? key, required this.name})
      : super(key: key);

  final String name;

  @override
  State<CardListDetailsSetWidget> createState() =>
      _CardListDetailsSetWidgetState();
}

class _CardListDetailsSetWidgetState extends State<CardListDetailsSetWidget> {
  String nameSet = '';
  final url = "https://db.ygoprodeck.com/api/v7";
  List<CardModel> dataCardList = [];

  Future<void> getCard() async {
    var nameSetEncode = Uri.encodeComponent(widget.name);
    final response = await http
        .get(Uri.parse("$url/cardinfo.php?language=fr&cardset=$nameSetEncode"));
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
    }
  }

  Future<void> refresh() async {
    setState(() {
      dataCardList = [];
    });
    await getCard();
  }

  Future<void> init() async {
    await getCard();
  }

  @override
  void initState() {
    init();
    nameSet = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des cartes'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: GridView.builder(
                  itemCount: dataCardList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          Padding(
                            padding:
                            const EdgeInsets.only(right: 2.0, left: 2.0),
                            child: Image.network(
                            width: 300, dataCardList[index].url),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
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
                                              : dataCardList[index].attribute ==
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
                                                                      width: 20,
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
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
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
                )),
          ],
        ),
      ),
    );
  }
}
