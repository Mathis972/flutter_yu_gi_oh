import 'package:flutter/material.dart';
import 'package:flutter_yu_gi_oh/widget/archetype_list_widget.dart';
import 'package:flutter_yu_gi_oh/widget/card_list_widget.dart';
import 'package:flutter_yu_gi_oh/widget/favorites_list_widget.dart';
import 'package:flutter_yu_gi_oh/widget/sets_list_widget.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _ongletActif = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const CardListWidget(),
    const SetsListWidget(),
    const FavoriteListWidget(),
    const ArchetipeListWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_ongletActif),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Cartes',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Sets et Editions',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.blueGrey,
          ),
        ],
        currentIndex: _ongletActif,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          setState(() {
            _ongletActif = index;
          });
        },
      ),
    );
  }
}
