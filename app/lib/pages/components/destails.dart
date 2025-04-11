import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String imagePath;

  const DetailPage({super.key, required this.title, required this.imagePath});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String selectedSection = 'Details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Image with buttons and title
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient for readability
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Back Button
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Like Button
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    // Like functionality here
                  },
                ),
              ),

              // Title
              Positioned(
                bottom: 20,
                left: 16,
                right: 100,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                  ),
                ),
              ),
            ],
          ),

          // Function Bar
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _functionLabel("Details"),
                    _functionLabel("Reviews"),
                    _functionLabel("Map"),
                    _functionLabel("Hotels"),
                  ],
                ),
              ),
            ),
          ),

          // Body content based on selected section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: _getSectionContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _functionLabel(String text) {
    final bool isSelected = selectedSection == text;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Color.fromARGB(255, 30, 30, 30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          minimumSize: Size(54, 23),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          setState(() {
            selectedSection = text;
          });
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _getSectionContent() {
    switch (selectedSection) {
      case 'Details':
        return Text(
          "Here are the full details about this place, including history, interesting facts, and cultural significance.",
        );
      case 'Reviews':
        return Text(
          "User Reviews:\n\n- Amazing place!\n- Must visit during spring.\n- Beautiful scenery and friendly locals.",
        );
      case 'Map':
        return Text(
          "Map view will be integrated here. It will show directions and nearby points of interest.",
        );
      case 'Hotels':
        return Text(
          "Nearby Hotels:\n\n1. Hotel Paradise\n2. Nature Stay Inn\n3. Budget Lodge",
        );
      default:
        return Text("No content available.");
    }
  }
}
