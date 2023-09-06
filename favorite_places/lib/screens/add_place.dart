import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/providers/user_places.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _addPlace() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedImage == null || _selectedLocation == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text('Enter favorite place\'s image and location'),
            action: SnackBarAction(
              label: 'Continue',
              onPressed: () {
                return;
              },
            ),
          ),
        );
        return;
      }

      ref
          .read(userPlacesProvider.notifier)
          .addPlace(_enteredTitle, _selectedImage!, _selectedLocation!);

      Navigator.pop(context);

      // Navigator.of(context).pop(Place(title: _enteredTitle));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onBackground),
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1) {
                    return 'Must be greater than 1';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredTitle = value!;
                },
              ),
              const SizedBox(height: 16),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(height: 16),
              LocationInput(
                onSelectedlocation: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addPlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
