import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/pages/ApiFunctions/apis.dart';
import 'package:app/pages/components/destails.dart';

class TourismHome extends StatefulWidget {
  const TourismHome({super.key});
  @override
  State<TourismHome> createState() => _BannerWithCarouselPageState();
}

class _BannerWithCarouselPageState extends State<TourismHome> {
  List<Map<String, String>> bannerItems = [];
  List<Map<String, String>> NatureItems = [];
  List<Map<String, String>> HistoricalItems = [];
  List<Map<String, String>> BeachItems = [];
  List<Map<String, String>> WildLifeItems = [];
  List<List<Map<String, String>>> listofall = [];

  List<String> types = ['Nature', 'Beach', 'Wildlife', 'Historical'];

  late List<bool> _showSeeMoreList;
  late List<ScrollController> _scrollControllers;

  bool _showSearchBar = false;
  TextEditingController _searchController = TextEditingController();

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
    bannerItems = await gettouristplaces();
    NatureItems = await gettouristplacesspecific('Nature');
    HistoricalItems = await gettouristplacesspecific('Historical');
    BeachItems = await gettouristplacesspecific('Beach');
    WildLifeItems = await gettouristplacesspecific('Wildlife');

    setState(() {
      listofall = [NatureItems, BeachItems, WildLifeItems, HistoricalItems];
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
            bannerItems.isNotEmpty
                ? Stack(
                  children: [
                    CarouselSlider.builder(
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
                              // You can add search filtering logic here
                            },
                          ),
                        ),
                      ),
                  ],
                )
                : Center(child: CircularProgressIndicator(color: Colors.white)),

            ...List.generate(types.length, (i) {
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
                                    builder: (_) => const LatestReleasesPage(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child:
                        listofall.isNotEmpty
                            ? ListView.builder(
                              controller: _scrollControllers[i],
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              itemCount: listofall[i].length,
                              itemBuilder: (context, index) {
                                final item = listofall[i][index];
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
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(item['image']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                            : Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton(
          onPressed: () {
            // Add your map logic here
          },
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          child: Icon(Icons.location_on, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class LatestReleasesPage extends StatelessWidget {
  const LatestReleasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('All Releases', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text(
          'This is the new page for all latest releases.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
