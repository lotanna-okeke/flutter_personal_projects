import 'package:flutter/material.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/category.dart';
import '../models/meal.dart';

class MealItem extends StatelessWidget {
  const MealItem({
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

  void _selectedMeal(BuildContext context) {
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MealDetailsScreen(
                meal: meal,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          _selectedMeal(context);
        },
        child: Stack(
          children: [
            Hero(
              tag: meal.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fadeInDuration: const Duration(seconds: 3),
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
                // filterQuality: FilterQuality.high,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                // color: Colors.black54,
                color: Color.fromARGB(168, 35, 12, 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow
                          .ellipsis, //Very long text witll be cut with ...
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.headline6!.fontSize,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MealItemTrait(
                            icon: Icons.schedule,
                            label: "${meal.duration} min"),
                        // const SizedBox(width: 15),
                        MealItemTrait(icon: Icons.work, label: complexityText),
                        // const SizedBox(width: 15),
                        MealItemTrait(
                            icon: Icons.attach_money, label: affordabilityText),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
