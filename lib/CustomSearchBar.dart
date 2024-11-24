import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Template_Assets/ItemBar.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late List<String> searchSuggestions;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchSuggestions = []; //give default value before being updated asynchronously
    initialiseSearchHistory();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isSearchBarOpen = true;
        });
      } else {
        setState(() {
          isSearchBarOpen = false;
        });
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void initialiseSearchHistory() async {
    List<String> history = await getSearchHistory();
    setState(() {
      searchSuggestions = history;
    });
  }

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('search_history') ?? [];
    return history;
  }

  /*
  void saveSearchHistory(String input) async {
    if(input == ''){
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_history') ?? [];
    history.add(input);
    await prefs.setStringList("search_history", history);
    updateSearchSuggestions();
  }

  void removeSuggestion(String suggestion) async {
    List<String> newHistory = await getSearchHistory();
    newHistory.remove(suggestion);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("search_history", newHistory);
    setState(() {
      print("updated suggestions list");
      searchSuggestions = newHistory;
    });
  }

  void updateSearchSuggestions() async {
    List<String> updatedHistory = await getSearchHistory();
    setState(() {
      searchSuggestions = updatedHistory;
    });
    print(searchSuggestions);
  }
  */
  final String zeroWidthSpace = '\u200B';

  TextEditingController controller = TextEditingController();

  bool isSearchBarOpen = false;

  List<String> searchHistory = ["hi", "testing"];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
            onTap: () {
              // Show the search overlay when tapping the text field
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ),
      ],
    );
    /*return Focus(
      focusNode: focusNode,
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Search'),
            onSubmitted: (value) {
              saveSearchHistory(value);
            },
          ),
          Visibility(
            visible: isSearchBarOpen,
            child: Expanded(
              child: ListView.builder(
                itemCount: searchSuggestions.length,
                itemBuilder: (context, index) {
                  String item = searchSuggestions[index];
                  return ListTile(
                    title: Text(item),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeSuggestion(item); // Remove suggestion when clicked
                      },
                    ),
                    onTap: () {
                      controller.text = item;
                      FocusScope.of(context).requestFocus(focusNode); 
                      // Optionally do something else when a suggestion is tapped
                    },
                  );
                },
              )
            ),
          )
        ],
      )
    );*/


    /*return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          onSubmitted: (value) {
            print("on submitted");
            saveSearchHistory(value);
            //Removes focus so it doesn't redirect to another page, remove later
            FocusScope.of(context).unfocus();
          },
          leading: const Icon(Icons.search),
        );
      }, 
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(searchSuggestions.length, (int index) {
          final String item = searchSuggestions[index];
          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                //this solution doesn't work
                final currentText = controller.text;
                controller.text = currentText + zeroWidthSpace;
                controller.text = currentText;
                removeSuggestion(item);
              },
            ),
            onTap: () {
              setState(() {
                controller.text = item;
                controller.closeView(item);
              });
            },
          );
        });
      }
    );*/
  }
}

//pass in searchHistory for the initial SearchHistory and to add onto it
class CustomSearchDelegate extends SearchDelegate<String> {
  final String apiEndpoint = "https://8ifxq0xli6.execute-api.ap-southeast-2.amazonaws.com/v2";
  final String apiRoute = "/dynamoContainsScan?searchValue=";

  void saveSearchHistory(String input) async {
    if(input == ''){
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_history') ?? [];
    history.add(input);
    await prefs.setStringList("search_history", history);
  }

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('search_history') ?? [];
    return history;
  }

  void removeSuggestion(String suggestion) async {
    List<String> newHistory = await getSearchHistory();
    newHistory.remove(suggestion);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("search_history", newHistory);
    print("updated suggestions list");
    print(newHistory);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    String apiRequest = apiEndpoint + apiRoute + query;
    saveSearchHistory(query);

    return FutureBuilder<List<dynamic>>(
      future: fetchResults(apiRequest), // Call the fetchResults function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found'));
        } else {
          final results = snapshot.data!;
          /*print(results[0]['productName']['S']);
          return Text(
            "test"
          );*/
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              final price = result['price']['N'];
              final location = result['store']['S'];
              final name = result['productName']['S'];
              return ItemBar(
                image: "IMG", 
                price: price, 
                location: location, 
                name: name
              );
            },
          );
        }
      }
    );
  }

  

  Future<List<dynamic>> fetchResults(String query) async {
    final url = Uri.parse(query); // Build the API URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Parse and return the results
    } else {
      throw Exception('Failed to load results');
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getSearchHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No suggestions found'));
        } else {
          //final searchHistory = snapshot.data!;
          final searchHistory = snapshot.data!.where((item) {
            return item.toLowerCase().contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: searchHistory.length,
            itemBuilder: (context, index) {
              final suggestion = searchHistory[index];
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  query = suggestion;
                },
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    removeSuggestion(suggestion);
                    query = ' ';
                    query = ''; 
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

