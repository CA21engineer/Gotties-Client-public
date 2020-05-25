import 'package:flutter/material.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/util/typedefs.dart';
import 'package:provider/provider.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({this.onTapSearchBar});

  @required
  final VoidFunction onTapSearchBar;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: Provider.of<FocusNodeStore>(context).focusNode,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      textAlign: TextAlign.center,
      maxLines: 1,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        icon: Icon(
          Icons.search,
          color: Colors.white70,
        ),
        hintText: '検索したいカテゴリを入力してください',
        hintStyle: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w100),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onTap: onTapSearchBar,
      onChanged: (word) {
        Provider.of<CategoryRepository>(context, listen: false).searchCategory(word);
      },
    );
  }
}
