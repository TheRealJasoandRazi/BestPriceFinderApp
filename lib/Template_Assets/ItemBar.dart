import 'package:flutter/material.dart';

class ItemBar extends StatelessWidget {
  final String image;
  final String price;
  final String location;
  final String name;

  const ItemBar({
    super.key,
    required this.image,
    required this.price,
    required this.location,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FractionallySizedBox(
        widthFactor: 0.8, // Takes up 80% of the screen width
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8), // Adds rounded corners if desired
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Using Expanded instead of flexible causes the widget to try and expand verrtically since its in a column even if theres no room, causing an error, use flexible instead
              Flexible( // IMAGE section
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  child: Center(
                    child: Text(
                      image,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ),
              Flexible( // METADATA section
                flex: 2,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "$price • $location",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Flexible( // BUTTON section
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  child: const Center(
                    child: Text(
                      "ADD TO LIST",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}