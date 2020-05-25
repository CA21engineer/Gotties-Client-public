import 'package:flutter/material.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/pages/home/category/category_tile.dart';
import 'package:gottiesclient/models/entities/entities.dart';
import 'package:gottiesclient/util/typedefs.dart';
import 'package:provider/provider.dart';

class CategoryModal extends StatefulWidget {
  const CategoryModal({this.statusHeight});

  @required
  final double statusHeight;

  @override
  _CategoryModalState createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  @override
  void didUpdateWidget(CategoryModal oldWidget) {
    Provider.of<FocusNodeStore>(context, listen: false).onShowModal();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    Provider.of<FocusNodeStore>(context, listen: false).onCloseModal();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - kToolbarHeight - widget.statusHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[200],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Flexible(
            child: _buildCategoryList(
              context,
              Provider.of<CategoryRepository>(context).searchedCategories,
              (category) {
                Provider.of<ArticleRepository>(context, listen: false).filterArticles(category);
                Provider.of<CategoryRepository>(context, listen: false).onSelectCategory(category);
                Navigator.pop<void>(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categories, VoidCategoryFunction onTapCategory) {
    return categories == null
        ? const CircularProgressIndicator()
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) => CategoryTile(
              category: categories[index],
              onTapCategory: onTapCategory,
            ),
          );
  }
}
