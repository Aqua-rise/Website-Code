import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 54, 75, 101),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Questure',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 15, 27, 41),
                  hintText: 'Search quiz by name or id',
                  hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Layout Builder for quiz tiles and background container
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double width = constraints.maxWidth;
                  int tilesPerRow;
                  if (width >= 1300) {
                    tilesPerRow = 4;
                  } else if (width >= 1150) {
                    tilesPerRow = 3;
                  } else if (width >= 850) {
                    tilesPerRow = 2;
                  } else {
                    tilesPerRow = 1;
                  }

                  return Container(
                    constraints: BoxConstraints(minHeight: screenHeight * 0.6),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 15, 27, 41),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16.0),
                        child: Wrap(
                          spacing: 20.0,
                          runSpacing: 25.0,
                          children: List.generate(
                            tilesPerRow * 2, //Affects the number of tiles
                            (index) => buildTile(
                                'Tile ${index + 1}',
                                width /
                                    tilesPerRow), //tile information for the buildTile widget
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTile(String title, double width) {
    return Container(
      width: width * .95,
      height: 170,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 54, 75, 101),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ContentPage()));
