import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meal_provider.dart';

enum Filter {
  gluttenFree,
  lactoseFree,
  vegan,
  vegetarians,
}

class FiltersNotififer extends StateNotifier<Map<Filter, bool>> {
  FiltersNotififer()
      : super({
          Filter.gluttenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarians: false,
          Filter.vegan: false,
        });

  // void setFilters(Map<Filter, bool> chosenFilters) {
  //   state = chosenFilters;
  // }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotififer, Map<Filter, bool>>(
        (ref) => FiltersNotififer());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.gluttenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarians]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
