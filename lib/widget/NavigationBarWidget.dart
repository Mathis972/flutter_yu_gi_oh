import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/widget/ArchetipeListWidget.dart';
import 'package:flutter_yu_gi_oh/widget/CardListwidget.dart';
import 'package:flutter_yu_gi_oh/widget/FavoriteListWidget.dart';
import 'package:flutter_yu_gi_oh/widget/SetsListWidget.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _ongletActif = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    CardListWidget(),
    SetsListWidget(),
    FavoriteListWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _ongletActif, // indice de l'onglet actif
        onTap: (index) {
          setState(() {
            _ongletActif = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Cartes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Sets et packs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
        ],
      ),
      body: Container(child: _widgetOptions.elementAt(_ongletActif)),
    );
  }
}
