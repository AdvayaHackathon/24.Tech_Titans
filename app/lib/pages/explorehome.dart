import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latest Episodes',
      debugShowCheckedModeBanner: false,
      home: LatestEpisodesPage(),
    );
  }
}

class LatestEpisodesPage extends StatefulWidget {
  const LatestEpisodesPage({super.key});

  @override
  State<LatestEpisodesPage> createState() => _LatestEpisodesPageState();
}

class _LatestEpisodesPageState extends State<LatestEpisodesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  List<Map<String, String>> episodes = List.generate(
    10,
    (i) => makeEpisode(i + 1, titles[i], subtitles[i], durations[i]),
  );

  static final titles = [
    "Shruthi's Shocking Deci...",
    "Kaveri Dies",
    "Bhagya's Bold Advice",
    "Veera's Plot Against Ved...",
    "Ajith's Silent Longing",
    "Bhadra Meets Jeeva",
    "Drishti's Second Win",
    "Manjula Saves Raghu",
    "Venkatesh Tells Arundat...",
    "Vadhu in Danger",
  ];

  static final subtitles = [
    'S1 E440 • 11 Apr',
    'S2 E604 • 10 Apr',
    'S1 E761 • 11 Apr',
    'S2 E194 • 11 Apr',
    'S1 E176 • 11 Apr',
    'S1 E253 • 11 Apr',
    'S1 E187 • 11 Apr',
    'S1 E55 • 11 Apr',
    'S1 E203 • 11 Apr',
    'S1 E99 • 11 Apr',
  ];

  static final durations = [
    '21m',
    '21m',
    '21m',
    '20m',
    '21m',
    '21m',
    '20m',
    '41m',
    '21m',
    '21m',
  ];

  static Map<String, String> makeEpisode(
    int num,
    String title,
    String subtitle,
    String duration,
  ) {
    return {
      'image': 'https://via.placeholder.com/150x90.png?text=Episode+$num',
      'title': title,
      'subtitle': subtitle,
      'duration': duration,
    };
  }

  List<Map<String, String>> get _filteredEpisodes {
    if (_searchQuery.isEmpty) return episodes;
    return episodes
        .where(
          (ep) =>
              ep['title']!.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.black,
                toolbarHeight: 50,
                title:
                    _isSearching
                        ? TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Explore New Places and Cultures',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        )
                        : const Text(
                          'Latest Episodes Before TV',
                          style: TextStyle(color: Colors.white),
                        ),
                actions: [
                  IconButton(
                    icon: Icon(_isSearching ? Icons.close : Icons.search),
                    onPressed: () {
                      setState(() {
                        if (_isSearching) {
                          _searchController.clear();
                          _searchQuery = '';
                        }
                        _isSearching = !_isSearching;
                      });
                    },
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final episode = _filteredEpisodes[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                episode['image']!,
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                color: Colors.black54,
                                child: Text(
                                  episode['duration']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 4,
                              left: 4,
                              child: Icon(
                                Icons.play_circle_fill,
                                size: 24,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          episode['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          episode['subtitle']!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }, childCount: _filteredEpisodes.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.2,
                  ),
                ),
              ),
            ],
          ),

          // Floating bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1E1E), Color(0xFF2D2D2D)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _FloatingTab(label: 'Tourism'),
                  _FloatingTab(label: 'Culture'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingTab extends StatelessWidget {
  final String label;

  const _FloatingTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
