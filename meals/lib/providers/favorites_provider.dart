import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavoriteMealNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final isExisiting = state.contains(meal);
    if (isExisiting) {
      // favoriteMeals.remove(meal);
      // state = favoriteMeals; //they didnt work cause they didnt change it immediately
      //or
      state = state.where((element) => element.id != meal.id).toList();
      return false;
    } else {
      // favoriteMeals.add(meal);
      // state = favoriteMeals;
      //or
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealNotifier, List<Meal>>((ref) {
  return FavoriteMealNotifier();
});
