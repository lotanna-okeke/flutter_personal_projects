import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  PlacesList({
    super.key,
    required this.places,
  });

  final List<Place> places;

  void openPlace(BuildContext context, Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PlacesDetailsScreen(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void removePlace(Place place, int index) async {
      ref.read(userPlacesProvider.notifier).deletePlace(place.id);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Place Deleted'),
        ),
      );
    }

    Widget content = Center(
      child: Text(
        'No places added yet',
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );

    if (places.isNotEmpty) {
      content = ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(places[index].id),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.5),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8),
            child: Icon(Icons.delete),
          ),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            removePlace(places[index], index);
          },
          child: ListTile(
            onTap: () {
              openPlace(context, places[index]);
            },
            leading: Hero(
              tag: places[index].id,
              child: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(places[index].image),
              ),
            ),
            title: Text(
              places[index].title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(places[index].location.address),
          ),
        ),
      );
    }

    return content;
  }
}
