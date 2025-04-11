import 'package:app/pages/ApiFunctions/functions.dart';
import 'package:app/pages/culturehome.dart';
import 'package:app/pages/tourismhome.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/pages/ApiFunctions/apis.dart';
import 'components/destails.dart';
import 'explorehome.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(button: false), // Your banner carousel page
    TourismHome(),
    ExplorePage(),
    CultureHome(),
    MySpacePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: 'Tourism',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.festival_outlined),
            label: 'Culture',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Space'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool button;

  const HomePage({super.key, required this.button});
  @override
  State<HomePage> createState() => _BannerWithCarouselPageState();
}

class _BannerWithCarouselPageState extends State<HomePage> {
  List<Map<String, String>> bannerItems = [];
  List<Map<String, String>> latestReleases = [];
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
    bannerItems = await getbanneritems();
    latestReleases = await getbanneritems();
    setState(() {});
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Carousel with Search Icon
                SizedBox(
                  height: 400,
                  child: Stack(
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
                                        Colors.black.withOpacity(0.3),
                                        Colors.black.withOpacity(0.7),
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
                                          color: Colors.white,
                                          fontSize: 16,
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
                          autoPlayAnimationDuration: Duration(
                            milliseconds: 1000,
                          ),
                          autoPlayCurve: Curves.easeInOut,
                        ),
                      ),

                      // Search Icon
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
                              if (!_showSearchBar) _searchController.clear();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Horizontal carousels
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
                              'Latest Releases ${i + 1}',
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
                                            (_) => const LatestReleasesPage(),
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
                        child: ListView.builder(
                          controller: _scrollControllers[i],
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          itemCount: latestReleases.length,
                          itemBuilder: (context, index) {
                            final item = latestReleases[index];
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

          // Search Bar Overlay
          if (_showSearchBar)
            Positioned(
              top: 40,
              left: 16,
              right: 60,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    // Live search logic here
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton(
          onPressed: () {
            // Your map logic
          },
          backgroundColor: Colors.black,
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

class MySpacePage extends StatelessWidget {
  const MySpacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Search Page", style: TextStyle(color: Colors.white)),
    );
  }
}
