import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference touristcollection = FirebaseFirestore.instance
    .collection('touristplaces');
final CollectionReference usercollection = FirebaseFirestore.instance
    .collection('users');
final CollectionReference imagescollection = FirebaseFirestore.instance
    .collection('images');

Future<List<Map<String, String>>> getbanneritems() async {
  print("Entered getbanneritems()");
  final List<Map<String, String>> banneritems = [];
  try {
    QuerySnapshot popularplaces =
        await touristcollection
            .limit(5)
            .where('review_rating', isGreaterThan: 4.0)
            .get();
    print("done fetching popular places $popularplaces");
    for (var placeDoc in popularplaces.docs) {
      String placeId = placeDoc.id;
      String title = placeDoc['name'];
      String city = placeDoc['city'];
      // Step 2: Fetch only one image for this place
      QuerySnapshot imagesSnapshot =
          await imagescollection
              .where('placeId', isEqualTo: placeId)
              .limit(1)
              .get();
      print("done fetching images for $placeId");

      String? imageUrl;
      if (imagesSnapshot.docs.isNotEmpty) {
        imageUrl = imagesSnapshot.docs.first['imageUrl'];
      }

      // Step 3: Combine into a JSON-like map
      banneritems.add({
        'title': title,
        'image': imageUrl ?? '',
        'city': city, // Use empty string if no image found
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(banneritems);
  return banneritems;
}

Future<List<Map<String, String>>> gettouristplaces() async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await touristcollection
            .limit(5)
            .where('significance', whereIn: ['Nature', 'Beach', 'Wildlife'])
            .get();
    print("done fetching popular places $popularplaces");
    for (var placeDoc in popularplaces.docs) {
      String placeId = placeDoc.id;
      String title = placeDoc['name'];
      String city = placeDoc['city'];
      // Step 2: Fetch only one image for this place
      QuerySnapshot imagesSnapshot =
          await imagescollection
              .where('placeId', isEqualTo: placeId)
              .limit(1)
              .get();
      print("done fetching images for $placeId");

      String? imageUrl;
      if (imagesSnapshot.docs.isNotEmpty) {
        imageUrl = imagesSnapshot.docs.first['imageUrl'];
      }

      // Step 3: Combine into a JSON-like map
      touristplaces.add({
        'title': title,
        'image': imageUrl ?? '',
        'city': city, // Use empty string if no image found
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(touristplaces);
  return touristplaces;
}

Future<List<Map<String, String>>> getcultureplaces() async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await touristcollection
            .limit(5)
            .where(
              'significance',
              whereIn: ['Culture', 'Religious', 'Historical'],
            )
            .get();
    print("done fetching popular places $popularplaces");
    for (var placeDoc in popularplaces.docs) {
      String placeId = placeDoc.id;
      String title = placeDoc['name'];
      String city = placeDoc['city'];
      // Step 2: Fetch only one image for this place
      QuerySnapshot imagesSnapshot =
          await imagescollection
              .where('placeId', isEqualTo: placeId)
              .limit(1)
              .get();
      print("done fetching images for $placeId");

      String? imageUrl;
      if (imagesSnapshot.docs.isNotEmpty) {
        imageUrl = imagesSnapshot.docs.first['imageUrl'];
      }

      // Step 3: Combine into a JSON-like map
      touristplaces.add({
        'title': title,
        'image': imageUrl ?? '',
        'city': city, // Use empty string if no image found
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(touristplaces);
  return touristplaces;
}
