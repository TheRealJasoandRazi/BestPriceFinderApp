import 'package:flutter/material.dart';
import '../Template_Assets/ItemBar.dart';

//DEPRECATED
class ResultsPage extends StatefulWidget {
  final List<dynamic> results;

  const ResultsPage({
    Key? key, 
    required this.results
  }) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index){
        final item = widget.results[index];
        final price = item['price']['N'];
        final location = item['store']['S'];
        final name = item['productName']['S'];
        return ItemBar(
          image: "IMG", 
          price: price, 
          location: location, 
          name: name
        );
      }
    );
  }
}