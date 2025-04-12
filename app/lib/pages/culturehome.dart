import 'package:app/pages/components/add_Culture.dart';
import 'package:app/pages/components/all_places.dart';
import 'package:app/pages/components/mapscreen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/pages/ApiFunctions/functions.dart';
import 'package:app/pages/ApiFunctions/apis.dart';
import 'package:app/pages/components/destails.dart';

class CultureHome extends StatefulWidget {
  const CultureHome({super.key});
  @override
  State<CultureHome> createState() => _CultureHomeState();
}

class _CultureHomeState extends State<CultureHome> {
  List<Map<String, String>> bannerItems = [];
  List<Map<String, String>> UpcomingFest = [];
  List<Map<String, String>> FestivalsPlaces = [];
  List<Map<String, String>> CulturalEvents = [];
  List<Map<String, String>> ReligiousFestivals = [];
  List<Map<String, String>> ReligiousSites = [];
  List<List<Map<String, String>>> Listofall = [];

  List<String> types = [
    'Upcoming Festivals in ${getCurrentMonth()}',
    'Festivals',
    'Cultural Events',
    'Religious Festivals',
    'Religious Sites',
  ];

  late List<bool> _showSeeMoreList;
  late List<ScrollController> _scrollControllers;

  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    int numberOfSliders = 5;
    _showSeeMoreList = List.generate(numberOfSliders, (_) => false);
    _scrollControllers = List.generate(numberOfSliders, (index) {
      final controller = ScrollController();
      controller.addListener(() {
        if (controller.offset > 150 && !_showSeeMoreList[index]) {
          setState(() {
            _showSeeMoreList[index] = true;
          });
        } else if (controller.offset <= 150 && _showSeeMoreList[index]) {
          setState(() {
            _showSeeMoreList[index] = false;
          });
        }
      });
      return controller;
    });
  }

  Future<void> fetchData() async {
    bannerItems = await getcultureplaces();
    UpcomingFest = await getupcomingcultureplaces();
    FestivalsPlaces = await getculturalplacesspecific("Festival");
    ReligiousFestivals = await getculturalplacesspecific("Religious Festival");
    CulturalEvents = await getculturalplacesspecific("Cultural Event");
    ReligiousSites = await getculturalplacesspecific("Religious Site");
    setState(() {
      Listofall = [
        UpcomingFest,
        FestivalsPlaces,
        CulturalEvents,
        ReligiousFestivals,
        ReligiousSites,
      ];
    });
  }

  @override
  void dispose() {
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section with Search Bar on top
            Stack(
              children: [
                bannerItems.isEmpty
                    ? Container(
                      height: 400,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : CarouselSlider.builder(
                      itemCount: bannerItems.length,
                      itemBuilder: (context, index, realIndex) {
                        final banner = bannerItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DetailPage(
                                      title: banner['title']!,
                                      imagePath: banner['image']!,
                                    ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                banner['image']!,
                                width: double.infinity,
                                height: 400,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                height: 400,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 34,
                                left: 16,
                                child: Text(
                                  banner['title']!,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                left: 16,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      banner['city']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 400,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 1000),
                        autoPlayCurve: Curves.easeInOut,
                      ),
                    ),
                // Search icon
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      _showSearchBar ? Icons.close : Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        _showSearchBar = !_showSearchBar;
                      });
                    },
                  ),
                ),
                // Search bar
                if (_showSearchBar)
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 64,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Search places...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.black),
                        ),
                        onChanged: (value) {
                          // Optional: Add your search filtering logic here
                        },
                      ),
                    ),
                  ),
              ],
            ),
            // Repeated Horizontal Lists
            ...List.generate(5, (i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          types[i],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _showSeeMoreList[i] ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              if (_showSeeMoreList[i]) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => AllPlaces(
                                          function: Listofall[i],
                                          title: types[i],
                                        ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Horizontal Carousel
                  Listofall.isEmpty
                      ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : SizedBox(
                        height: 180,
                        child: ListView.builder(
                          controller: _scrollControllers[i],
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          itemCount: Listofall[i].length,
                          itemBuilder: (context, index) {
                            final item = Listofall[i][index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailPage(
                                          title: item['title']!,
                                          imagePath: item['image']!,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 12),
                                width: 120,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item['image']!,
                                        width: 120,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          item['date'] ?? 'N/A',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 28,
                                      left: 8,
                                      right: 8,
                                      child: Text(
                                        item['title'] ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 8,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            item['city'] ?? '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                ],
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.location_on, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapScreen(name: "Cultural"),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(0, 0, 0, 0), // Make the background transparent
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CultureFormPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // Background color of the button
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_location),
                  Text(
                    'Add New Places',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
