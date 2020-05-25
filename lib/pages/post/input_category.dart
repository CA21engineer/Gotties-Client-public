import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:gottiesclient/models/stores/post_page_store.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/pages/home/category/category_list.dart';
import 'package:provider/provider.dart';

class InputCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PostPageStore>(context).categoryController;
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'リビング、キッチン、etc.',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onChanged: (word) => Provider.of<CategoryRepository>(context, listen: false).searchCategory(word),
          ),
          const SizedBox(
            height: 16,
          ),
          Bubble(
            nip: BubbleNip.leftTop,
            color: Colors.red[200],
            child: Container(
              height: 70,
              child: CategoryList(
                scrollDirection: Axis.horizontal,
                onTapCategory: (category) {
                  final store = Provider.of<CategoryRepository>(
                    context,
                    listen: false,
                  )..onSelectCategory(category);
                  controller.text = store.selectedCategory.title;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
