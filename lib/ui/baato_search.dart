import 'package:flutter/material.dart';
import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/search.dart';

import '../main.dart';

class BaatoSearchExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Baato Search"),
        backgroundColor: Color.fromRGBO(8, 30, 42, 50),
      ),
      body: SearchListViewExample(),
    );
  }
}

class SearchListViewExample extends StatefulWidget {
  @override
  _SearchListViewExampleState createState() => _SearchListViewExampleState();
}

class _SearchListViewExampleState extends State<SearchListViewExample> {
  List<Search>? searchResults = <Search>[];
  List<Search>? tempList = <Search>[];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _searchBar(),
              Expanded(
                flex: 1,
                child: _mainData(),
              )
            ],
          ),
        ));
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search here...",
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (text) {
          _searchBaatoPlaces(text);
        },
      ),
    );
  }

  Widget _mainData() {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: searchResults!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    searchResults![index].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(searchResults![index].address),
                  leading: Icon(Icons.location_pin),
                );
              }),
    );
  }

  _searchBaatoPlaces(String query) async {
    setState(() {
      isLoading = true;
    });
    tempList = <Search>[];

    String baatoAccessToken = BaatoExampleApp.BAATO_ACCESS_TOKEN;
    BaatoSearch baatoSearch = BaatoSearch.initialize(
      query: query,
      accessToken: baatoAccessToken,
      // type: 'school', //optional parameter
      limit: 5, //optional parameter
    );

    //perform Search
    SearchResponse response = await baatoSearch.searchQuery();
    if (response != null && response.status == 200) tempList = response.data;

    setState(() {
      searchResults = tempList;
      isLoading = false;
    });
  }
}
