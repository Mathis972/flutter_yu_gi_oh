import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/model/cart.dart';
import 'package:flutter_yu_gi_oh/widget/card_details_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FavoriteListWidget extends StatefulWidget {
  const FavoriteListWidget({super.key});

  @override
  _FavoriteListWidgetState createState() => _FavoriteListWidgetState();
}

class _FavoriteListWidgetState extends State<FavoriteListWidget> {
  List<String> favList = [];
  List<CardModel> dataCardList = [];
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
          dataCardList.add(CardModel.fromJson(element));
        });
      }
    }
  }

  Future<void> init() async {
    await getFavList();
    await getCard();
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
        actions: [
          IconButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.infoReverse,
                  headerAnimationLoop: true,
                  animType: AnimType.bottomSlide,
                  title:
                      'Double click sur une carte des listes pour les ajouter aux favoris',
                  reverseBtnOrder: true,
                  btnOkText: 'Compris',
                  btnOkOnPress: () {},
                ).show();
              },
              icon: const Icon(Icons.info))
        ],
        title: const Text('Liste des favoris'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          Expanded(
              child: GridView.builder(
            itemCount: dataCardList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.6,
              crossAxisCount: 6,
              crossAxisSpacing: 0.5,
            ),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0, left: 2.0),
                      child: Image.network(width: 100, dataCardList[index].url),
                    ),
                  ],
                ),
              );
            },
          )),
        ]),
      ),
    );
  }
}
