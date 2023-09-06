import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/filters_provider.dart';
import 'package:meals/screens/meals.dart';

// final selectedCategoryProvider = Provider((ref) {
//   final availableMeals = ref.watch(filteredMealsProvider);

//   void displayCategory(BuildContext context, {required Category category}) {
//     final filteredMeals = availableMeals
//         .where((meal) => meal.categories.contains(category.id))
//         .toList();

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MealsScreen(
//           title: category.title,
//           meals: filteredMeals,
//           selectedCategory: displayCategory,
//         ),
//       ),
//     );
//   }
// });

class selectedCategoryNotifier extends StateNotifier<List<Meal>> {
  selectedCategoryNotifier() : super([]);

  void displayCategory(
      {required BuildContext context,
      required WidgetRef ref,
      required Category category}) {
    final availableMeals = ref.watch(filteredMealsProvider);
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }
}

final selectedCategoryProvider =
    StateNotifierProvider<selectedCategoryNotifier, List<Meal>>((ref) {
  return selectedCategoryNotifier(); //selectedCategoryNotifier(ref.read());
});
