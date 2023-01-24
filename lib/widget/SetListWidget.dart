import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/model/cart.dart';
import 'package:flutter_yu_gi_oh/widget/CardDetailsWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SetListWidget extends StatefulWidget {
  const SetListWidget({super.key});

  @override
  _SetListWidgetState createState() => _SetListWidgetState();
}

class _SetListWidgetState extends State<SetListWidget> {
  List<String> favList = [];
  List<cardModel> dataCardList = [];
  final url = "https://db.ygoprodeck.com/api/v7";

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
    final response = await http.get(
        Uri.parse("$url/cardinfo.php?language=fr&id=${favList.join(',')}"));
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

  Future<void> init() async {
    await getFavList();
    await getCard();
  }

  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des sets'),
      ),
      body: Column(children: [
        Text('ListCarte'),
        Text('Cartes favorites ❤️',
            style: Theme.of(context).textTheme.headline5),
        Expanded(
          child: dataCardList != null
              ? ListView.builder(
                  itemCount: dataCardList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onDoubleTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        if (favList.isNotEmpty) {
                          favList.remove(dataCardList[index].id.toString());
                        }
                        await prefs.setStringList('favs', favList);
                        setState(() {
                          favList = favList;
                          dataCardList.remove(dataCardList[index]);
                        });
                      },
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
                                width: 100, dataCardList[index].url),
                          )),
                        ],
                      ),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ]),
    );
  }
}
