import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gottiesclient/models/entities/entities.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/pages/home/article_tile.dart';
import 'package:gottiesclient/util/typedefs.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({this.articles, this.onTapTile, this.onRefresh, this.controller});

  @required
  final List<Article> articles;
  @required
  final VoidArticleFunction onTapTile;
  @required
  final FutureVoidFunction onRefresh;
  @required
  final RefreshController controller;

  @override
  Widget build(BuildContext context) {
    return _buildArticleList(context);
  }

  Widget _buildArticleList(BuildContext context) {
    return articles == null
        ? const CircularProgressIndicator()
        : Expanded(
            child: SmartRefresher(
              controller: controller,
              header: const WaterDropHeader(
                waterDropColor: Colors.lightBlueAccent,
              ),
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 16, left: 8, bottom: 8),
                          child: Text(
                            '${Provider.of<CategoryRepository>(context).selectedCategory?.title ?? 'ALL'}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ArticleTile(
                          article: articles[index],
                          onTapTile: onTapTile,
                        ),
                      ],
                    );
                  }
                  return ArticleTile(
                    article: articles[index],
                    onTapTile: onTapTile,
                  );
                },
              ),
            ),
          );
  }
}
