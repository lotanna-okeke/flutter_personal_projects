import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/selectCategory_provider.dart';

import '../models/meal.dart';
import '../widgets/meal_item_trait.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  List<String> get categoryTitle {
    List<String> titles = [];
    final mealCategories = List.of(meal.categories);
    // meal.categories.
    for (var i in mealCategories) {
      for (var j in availableCategories) {
        if (j.id == i) {
          titles.add(j.title);
          break;
        }
      }
    }

    return titles;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    bool isFavorite = favoriteMeals.contains(meal);
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleMealFavoriteStatus(meal);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(wasAdded
                      ? 'Added to Favorites'
                      : 'Removed from Favorites')));
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(
                    begin: 0.8,
                    end: 1,
                  ).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(isFavorite),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                child: Stack(
                  children: [
                    Hero(
                      tag: meal.id,
                      child: Image.network(meal.imageUrl),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 44),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MealItemTrait(
                                icon: Icons.schedule,
                                label: "${meal.duration} min"),
                            // const SizedBox(width: 15),
                            MealItemTrait(
                                icon: Icons.work, label: complexityText),
                            // const SizedBox(width: 15),
                            MealItemTrait(
                                icon: Icons.attach_money,
                                label: affordabilityText),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Categories: \t",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          // fontSize: 20,
                        ),
                  ),
                  for (String cat in categoryTitle)
                    Expanded(
                        child: TextButton(
                      onPressed: () {
                        ref
                            .read(selectedCategoryProvider.notifier)
                            .displayCategory(
                                ref: ref,
                                context: context,
                                category: availableCategories[
                                    availableCategories.indexWhere(
                                        (element) => element.title == cat)]);
                      },
                      child: Text(cat,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 15)),
                    ))
                ],
              ),
            ),

            const SizedBox(height: 20),
            //for the ingredients
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            const SizedBox(height: 25),
            //Fot the steps
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            // const SizedBox(height: 8),
            for (final step in meal.steps)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              )
          ],
        ),
      ),
    );
  }
}
