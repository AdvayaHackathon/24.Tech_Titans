import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LatestEpisodesScreen(),
    ),
  );
}

class LatestEpisodesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> episodes = [
    {
      'title': "Shruthi's Shocking Deci...",
      'episode': 'S1 E440',
      'date': '11 Apr',
      'duration': '21m',
      'image': 'https://your_image_url_1.jpg',
    },
    {
      'title': "Kaveri Dies",
      'episode': 'S2 E604',
      'date': '10 Apr',
      'duration': '21m',
      'image': 'https://your_image_url_2.jpg',
    },
    {
      'title': "Bhagya's Bold Advice",
      'episode': 'S1 E761',
      'date': '11 Apr',
      'duration': '21m',
      'image': 'https://your_image_url_3.jpg',
    },
    {
      'title': "Veera's Plot Against Ved...",
      'episode': 'S2 E194',
      'date': '11 Apr',
      'duration': '20m',
      'image': 'https://your_image_url_4.jpg',
    },
    {
      'title': "Ajith's Silent Longing",
      'episode': 'S1 E176',
      'date': '11 Apr',
      'duration': '21m',
      'image': 'https://your_image_url_5.jpg',
    },
    {
      'title': "Bhadra Meets Jeeva",
      'episode': 'S1 E253',
      'date': '11 Apr',
      'duration': '21m',
      'image': 'https://your_image_url_6.jpg',
    },
    {
      'title': "Drishti's Second Win",
      'episode': 'S1 E187',
      'date': '11 Apr',
      'duration': '20m',
      'image': 'https://your_image_url_7.jpg',
    },
    {
      'title': "Manjula Saves Raghu",
      'episode': 'S1 E55',
      'date': '11 Apr',
      'duration': '41m',
      'image': 'https://your_image_url_8.jpg',
    },
    {
      'title': "Venkatesh Tells Arundat...",
      'episode': '',
      'date': '11 Apr',
      'duration': '21m',
      'image': 'https://your_image_url_9.jpg',
    },
    {
      'title': "Vadhu in Danger",
      'episode': '',
      'date': '11 Apr',
      'duration': '21m',
      'image': 'https://your_image_url_10.jpg',
    },
  ];

  LatestEpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Latest Episodes Before TV',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: episodes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final episode = episodes[index];
            return GestureDetector(
              onTap: () {},
              child: EpisodeCard(episode: episode),
            );
          },
        ),
      ),
    );
  }
}

class EpisodeCard extends StatelessWidget {
  final Map<String, dynamic> episode;

  const EpisodeCard({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            episode['image'],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      '${episode['episode']} • ${episode['date']}',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    Spacer(),
                    Text(
                      episode['duration'],
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
