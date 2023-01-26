import 'dart:convert';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/widget/cardListDetailsSetWidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/cart.dart';

class SetsListWidget extends StatefulWidget {
  const SetsListWidget({super.key});

  @override
  _SetsListWidgetState createState() => _SetsListWidgetState();
}

class _SetsListWidgetState extends State<SetsListWidget> {
  @override
  final url = "https://db.ygoprodeck.com/api/v7";
  List<CardSet> dataSetList = [];
  TextEditingController nameController = TextEditingController();
  var name = '';
  Map<String, bool> sortingDesc = {
    'numCard': false,
    'releaseDate': false,
  };

  Future<void> loadData() async {
    final response = await http.get(Uri.parse(url + "/cardsets.php"));
    if (response.statusCode == 400) {
      dataSetList = [];
    }
    if (response.statusCode == 200) {
      final jsonConvert = jsonDecode(response.body);
      List<dynamic> jsonList = jsonConvert;
      for (var element in jsonList) {
        setState(() {
          dataSetList.add(CardSet.fromJson(element));
        });
      }
    }
  }

  Future<void> init() async {
    await loadData();
  }

  void initState() {
    super.initState();
    init();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des sets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              showAdaptiveActionSheet(
                context: context,
                actions: <BottomSheetAction>[
                  BottomSheetAction(
                    title: const Text('Trier par nom A-Z'),
                    onPressed: (_) {
                      setState(() {
                        dataSetList
                            .sort((a, b) => (a.name?.compareTo(b.name) ?? 0));
                      });
                    },
                  ),
                  BottomSheetAction(
                    title: const Text('Trier par nom Z-A'),
                    onPressed: (_) {
                      setState(() {
                        dataSetList
                            .sort((a, b) => (b.name?.compareTo(a.name) ?? 0));
                      });
                    },
                  ),
                  BottomSheetAction(
                    title: const Text('Trier par nombre de cartes'),
                    onPressed: (_) {
                      setState(() {
                        sortingDesc.forEach((key, value) {
                          if (key != 'numCard')
                            sortingDesc[key] = false;
                          else
                            sortingDesc[key] = !sortingDesc[key]!;
                        });
                        dataSetList.sort((a, b) => (sortingDesc['numCard'] ??
                                false
                            ? b.numCard?.compareTo(a.numCard?.toInt() ?? 0) ?? 0
                            : a.numCard?.compareTo(b.numCard?.toInt() ?? 0) ??
                                0));
                      });
                    },
                  ),
                  BottomSheetAction(
                    title: const Text('Trier par date de sortie'),
                    onPressed: (_) {
                      setState(() {
                        sortingDesc.forEach((key, value) {
                          if (key != 'releaseDate')
                            sortingDesc[key] = false;
                          else
                            sortingDesc[key] = !sortingDesc[key]!;
                        });
                        dataSetList.sort((a, b) =>
                            (sortingDesc['releaseDate'] ?? false
                                ? b.releaseDate
                                        ?.compareTo(a.releaseDate.toString()) ??
                                    0
                                : a.releaseDate
                                        ?.compareTo(b.releaseDate.toString()) ??
                                    0));
                      });
                    },
                  ),
                ],
                cancelAction: CancelAction(title: const Text('Annuler')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: dataSetList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CardListDetailsSetWidget(
                    name: dataSetList[index].name,
                  ),
                ));
              },
              child: Card(
                margin: const EdgeInsets.only(right: 20, left: 20, top: 10),
                shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 10,
                child: ListTile(
                  title: Text(dataSetList[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                        child: Text("nombre de cartes: " +
                            dataSetList[index].numCard.toString() +
                            " cartes"),
                      ),
                      dataSetList[index].releaseDate != null ? Text(DateFormat.yMMMMd()
                          .format(DateTime.parse(
                              dataSetList[index].releaseDate.toString()))
                          .toString()) : Text(""),
                    ],
                  ),
                  trailing: Image.network(
                      errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  }, dataSetList[index].urlImage.toString(),
                      width: 50, height: 50),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
