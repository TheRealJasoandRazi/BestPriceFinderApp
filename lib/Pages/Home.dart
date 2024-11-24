import 'package:flutter/material.dart';
import '../Template_Assets/ItemBar.dart';
import '../CustomSearchBar.dart';
//import 'package:input_history_text_field/input_history_text_field.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 1, 
            child: CustomSearchBar(),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Popular Items:",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  )
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ItemBar(image: "IMAGE", price: "2.00", location: "Earth", name: "Mars Bar"),
                    ItemBar(image: "IMAGE", price: "1.50", location: "Mars", name: "Milky Way Bar"),
                    ItemBar(image: "IMAGE", price: "200", location: "Melbourne", name: "Cheese"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Recently Viewed:",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  )
                ),
                const Column(
                  children: [
                    ItemBar(image: "IMAGE", price: "2.00", location: "Earth", name: "Mars Bar"),
                    ItemBar(image: "IMAGE", price: "1.50", location: "Mars", name: "Milky Way Bar"),
                    ItemBar(image: "IMAGE", price: "200", location: "Melbourne", name: "Cheese"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
