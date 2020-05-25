import 'package:flutter/material.dart';
import 'package:gottiesclient/models/entities/entities.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/pages/home/category/category_tile.dart';
import 'package:gottiesclient/util/typedefs.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({this.onTapCategory, this.scrollDirection = Axis.vertical});

  @required
  final VoidCategoryFunction onTapCategory;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryRepository>(context).searchedCategories;
    return categories == null
        ? const CircularProgressIndicator()
        : ListView.builder(
            scrollDirection: scrollDirection,
            itemCount: categories.length,
            itemBuilder: (context, index) => CategoryTile(
              category: categories[index],
              onTapCategory: onTapCategory,
            ),
          );
  }
}
