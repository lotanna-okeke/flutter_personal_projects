import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:favorite_places/models/place.dart';

Future<Database> _getDatabase() async {
  final dbPath =
      await sql.getDatabasesPath(); //points to a directory to create a database
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)'); //Cretaes the db with the structure we want
    },
    version: 2,
  ); //will open path if it exists, if not will create it.
  return db;
}

class UserPlacesNotififer extends StateNotifier<List<Place>> {
  UserPlacesNotififer() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();

    // print('Test');
    final data = await db.query('user_places');
    // print(data);
    // var places = [2, 2, 2];
    // for (Map<String, Object?> row in data) {
    //   print(row['id'] as String);
    //   print(row['id'] as String);
    //   print(row['id'] as String);
    // }
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    final output = places.reversed.toList();
    state = output;
    // state = [...state];
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths
        .getApplicationDocumentsDirectory(); //gets the directory in the application
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace =
        Place(title: title, image: copiedImage, location: location);

    final db = await _getDatabase();

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address
    });

    state = [newPlace, ...state];
  }

  void deletePlace(String placeId) async {
    final db = await _getDatabase();
    // final deletedPlace =
    //     db.query('user_places', where: "id=?", whereArgs: [placeId]);

    await db.delete("user_places", where: "id=?", whereArgs: [placeId]);

    state = state.where((element) => element.id != placeId).toList();
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotififer, List<Place>>(
  (ref) => UserPlacesNotififer(),
);
