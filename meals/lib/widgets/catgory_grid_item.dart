import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/category.dart';
import 'package:meals/providers/selectCategory_provider.dart';

class CategoryGridItem extends ConsumerWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.selectedCategory,
  });

  final Category category;
  final void Function(BuildContext context, {required Category category})
      selectedCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref
            .read(selectedCategoryProvider.notifier)
            .displayCategory(category: category, context: context, ref: ref);
        // selectedCategory(context, category: category);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                category.color.withOpacity(0.2),
                category.color.withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(16)),
        child: Text(
          category.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
