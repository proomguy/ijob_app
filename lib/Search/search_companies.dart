import 'package:flutter/material.dart';

import '../Widgets/bottom_nav_bar.dart';

class AllWorkersScreen extends StatefulWidget {


  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {

  final TextEditingController searchQueryTextEditingController = TextEditingController();
  String searchQuery = 'Search Query';

  Widget _buildSearchField(){
    return TextField(
      controller: searchQueryTextEditingController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search for companies here....',
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 25
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions(){
    return <Widget>[
      IconButton(
        onPressed: (){
          _clearSearchQuery();
        },
        icon: const Icon(Icons.clear,
          size: 25,
          color: Colors.red,
        ),
      ),
    ];
  }

  void _clearSearchQuery(){
    setState(() {
      searchQueryTextEditingController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery){
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent.shade200, Colors.cyanAccent.shade200],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBarForMyApp(indexNum: 1),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyanAccent.shade200, Colors.orangeAccent.shade200],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
      ),
    );
  }
}
