import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _BannerWithCarouselPageState();
}

class _BannerWithCarouselPageState extends State<HomePage> {
  final List<Map<String, String>> bannerItems = [];

  final List<Map<String, String>> latestReleases = [];
  final List<Map<String, String>> releasesForSlider2 = [];

  late List<bool> _showSeeMoreList;
  late List<ScrollController> _scrollControllers;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
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
            // BANNER CAROUSEL
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
                      Image.asset(
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
                              // ignore: deprecated_member_use
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
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
            // Repeated Horizontal Carousels
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
                  // Horizontal Carousel
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(item['image']!),
                                fit: BoxFit.cover,
                              ),
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
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String imagePath;

  const DetailPage({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
          ),
        ],
      ),
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
