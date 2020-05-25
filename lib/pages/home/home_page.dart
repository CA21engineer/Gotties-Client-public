import 'package:flutter/material.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/pages/home/article_list.dart';
import 'package:gottiesclient/pages/home/category/category_modal.dart';
import 'package:gottiesclient/widgets/my_appbar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatelessWidget {
  void _buildCategoryModal(BuildContext context) {
    // methodに渡ってきた、HomePage(Scaffold)のcontextを使用してstatus barの高さを得る
    final statusHeight = MediaQuery.of(context).padding.top;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      barrierColor: const Color(0x01000000),
      builder: (context) => SingleChildScrollView(
        child: CategoryModal(
          statusHeight: statusHeight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = RefreshController();
    return Scaffold(
      appBar: MyAppBar(
        title: 'Home',
        showSearch: true,
        onTapSearchBar: () => _buildCategoryModal(context),
      ),
      body: Column(
        children: <Widget>[
          ArticleList(
            articles: Provider.of<ArticleRepository>(context).articles,
            onTapTile: (article) => Navigator.pushNamed(context, '/detail', arguments: article),
            onRefresh: () async {
              await Provider.of<ArticleRepository>(context, listen: false).getArticles();
              controller.refreshCompleted();
            },
            controller: controller,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/post'),
        child: Icon(Icons.add),
      ),
    );
  }
}
