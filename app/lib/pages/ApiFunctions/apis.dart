import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

final CollectionReference touristcollection = FirebaseFirestore.instance
    .collection('touristplaces');
final CollectionReference usercollection = FirebaseFirestore.instance
    .collection('users');
final CollectionReference imagescollection = FirebaseFirestore.instance
    .collection('images');
final CollectionReference culturalcollection = FirebaseFirestore.instance
    .collection('culturalfest');
final DateFormat formatter = DateFormat('yyyy-MM-dd');

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
            .where(
              'significance',
              whereIn: ['Nature', 'Beach', 'Wildlife', 'Historical'],
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

Future<List<Map<String, String>>> gettouristplacesspecific(type) async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await touristcollection.where('significance', isEqualTo: type).get();
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
              whereIn: ['Culture', 'Religious', 'Spiritual'],
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

Future<List<Map<String, String>>> getculturalplacesspecific(type) async {
  print("Entered getCulturalplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await culturalcollection.where('type', isEqualTo: type).get();
    print("done fetching popular places $popularplaces");
    for (var placeDoc in popularplaces.docs) {
      String placeId = placeDoc.id;
      String title = placeDoc['name'];
      String city = placeDoc['city'];
      DateTime date = placeDoc['date_of_organizing'].toDate();
      String formattedDate = "${date.day} ${DateFormat.MMMM().format(date)}";
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
        'city': city,
        'date': formattedDate, // Use empty string if no image found
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(touristplaces);
  return touristplaces;
}

Future<List<Map<String, String>>> getupcomingcultureplaces() async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await culturalcollection
            .limit(10)
            .where('date_of_organizing', isGreaterThan: DateTime.now())
            .get();
    print("done fetching popular places $popularplaces");
    for (var placeDoc in popularplaces.docs) {
      String placeId = placeDoc.id;
      String title = placeDoc['name'];
      String city = placeDoc['city'];
      DateTime date = placeDoc['date_of_organizing'].toDate();
      String formattedDate = "${date.day} ${DateFormat.MMMM().format(date)}";

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
        'city': city,
        'date': formattedDate, // Use empty string if no image found
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(touristplaces);
  return touristplaces;
}

Future<List<Map<String, String>>> getalltouristplaces() async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await touristcollection
            .limit(7)
            .orderBy('name', descending: false)
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

Future<List<Map<String, String>>> getallculturalplaces() async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await culturalcollection
            .limit(7)
            .orderBy('name', descending: false)
            .get();
    print("done fetching popular places $popularplaces");
    for (var placeDoc in popularplaces.docs) {
      String placeId = placeDoc.id;
      String title = placeDoc['name'];
      String city = placeDoc['city'];
      DateTime date = placeDoc['date_of_organizing'].toDate();
      String formattedDate = "${date.day} ${DateFormat.MMMM().format(date)}";
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
        'city': city,
        'date': formattedDate, // Use empty string if no image found
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(touristplaces);
  return touristplaces;
}

Future<List<Map<String, String>>> gettouristplacesbyseason(type) async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await touristcollection
            .limit(5)
            .where('best_season', isEqualTo: type)
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

Future<List<Map<String, String>>> gethighratedtouristplaces() async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await touristcollection
            .limit(5)
            .orderBy('review_rating', descending: true)
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

Future<Map<String, String>> getplacedetails(name) async {
  print("Entered getplacedetails()");
  Map<String, String> placedetails = {};
  try {
    await touristcollection.where('name', isEqualTo: name).get().then((
      snapshot,
    ) async {
      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first.data() as Map<String, dynamic>;
        placedetails['name'] = doc['name'];
        placedetails['city'] = doc['city'];
        placedetails['state'] = doc['state'];
        placedetails['significance'] = doc['significance'];
        placedetails['best_season'] = doc['best_season'];

        placedetails['zone'] = doc['zone'];
      } else {
        await culturalcollection.where('name', isEqualTo: name).get().then((
          snapshot,
        ) {
          if (snapshot.docs.isNotEmpty) {
            var doc = snapshot.docs.first.data() as Map<String, dynamic>;
            placedetails['name'] = doc['name'];
            placedetails['town'] = doc['town'];
            placedetails['district'] = doc['district'];
            placedetails['city'] = doc['city'];
            placedetails['type'] = doc['type'];
            placedetails['date_of_organizing'] = formatter.format(
              doc['date_of_organizing'].toDate(),
            );
            placedetails['date_of_ending'] = formatter.format(
              doc['date_of_ending'].toDate(),
            );
            placedetails['description'] = doc['description'];
          }
        });
      }
    });
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(placedetails);
  return placedetails;
}

Future<LatLng> getlatlong(name) async {
  print("Entered getlatlong()");
  LatLng latlng = LatLng(0, 0);
  try {
    await touristcollection.where('name', isEqualTo: name).get().then((
      snapshot,
    ) async {
      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first.data() as Map<String, dynamic>;
        latlng = LatLng(
          double.parse(doc['latitude']),
          double.parse(doc['longitude']),
        );
      } else {
        await culturalcollection.where('name', isEqualTo: name).get().then((
          snapshot,
        ) {
          if (snapshot.docs.isNotEmpty) {
            var doc = snapshot.docs.first.data() as Map<String, dynamic>;
            latlng = LatLng(
              double.parse(doc['latitude']),
              double.parse(doc['longitude']),
            );
          }
        });
      }
    });
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(latlng);
  return latlng;
}

Future<List<String>> getimages(name) async {
  List<String> images = [];
  try {
    var getdocid = await touristcollection
        .where('name', isEqualTo: name)
        .get()
        .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.id;
          } else {
            return null;
          }
        });
    if (getdocid != null) {
      await imagescollection.where('placeId', isEqualTo: getdocid).get().then((
        snapshot,
      ) {
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            images.add(doc['imageUrl']);
          }
        }
      });
    } else {
      print("No document found with the name $name");
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print("Done fetching images for $name");
  return images;
}

Future<List<Map<String, String>>> getlocationoftourismdetails() async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces =
        await touristcollection
            .where(
              'significance',
              whereIn: ["Nature", "Beach", "Wildlife", "Historical"],
            )
            .get();
    print("done fetching popular places $popularplaces");
    for (var placeDoc in popularplaces.docs) {
      String placeId = placeDoc.id;
      String title = placeDoc['name'];
      String longitude = placeDoc['longitude'];
      String latitude = placeDoc['latitude'];
      // Step 2: Fetch only one image for this place

      // Step 3: Combine into a JSON-like map
      touristplaces.add({
        'title': title,
        'longitude': longitude,
        'latitude': latitude, // Use empty string if no image found
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(touristplaces);
  return touristplaces;
}

Future<List<Map<String, String>>> getlocationofculturaldetails() async {
  print("Entered gettouristplaces()");
  final List<Map<String, String>> touristplaces = [];
  try {
    QuerySnapshot popularplaces = await culturalcollection.get();
    print("done fetching popular places $popularplaces");
    for (var placeDoc in popularplaces.docs) {
      String placeId = placeDoc.id;
      String title = placeDoc['name'];
      String longitude = placeDoc['longitude'];
      String latitude = placeDoc['latitude'];
      // Step 2: Fetch only one image for this place

      // Step 3: Combine into a JSON-like map
      touristplaces.add({
        'title': title,
        'longitude': longitude,
        'latitude': latitude, // Use empty string if no image found
      });
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  print(touristplaces);
  return touristplaces;
}
