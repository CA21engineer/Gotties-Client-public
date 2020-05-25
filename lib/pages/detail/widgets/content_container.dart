import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gottiesclient/models/entities/article.dart';
import 'package:gottiesclient/models/stores/share_store.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/util/converter.dart';
import 'package:gottiesclient/widgets/icon_button_with_splash.dart';
import 'package:provider/provider.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer({@required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.5,
      initialChildSize: 0.27,
      minChildSize: 0.27,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8),
                    height: 6,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'カテゴリ',
                      style: TextStyle(height: 2),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        article.category.title,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text('投稿日:${timeStampToJPDate(article.createdAt)}'),
                  ),
                  const Divider(),
                  Text(
                    article.body,
                    style: const TextStyle(
                      height: 1.6,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButtonWithSplash(
                        width: 45,
                        height: 45,
                        icon: Icon(
                          Provider.of<ArticleRepository>(context).isLike(article.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onTapButton: () {
                          final repository = Provider.of<ArticleRepository>(context, listen: false);
                          final isLike = repository.isLike(article.id);
                          if (isLike) {
                            repository.unlikeArticle(article.id);
                          } else {
                            repository.likeArticle(article.id);
                          }
                        },
                      ),
                      IconButtonWithSplash(
                        width: 45,
                        height: 45,
                        icon: Icon(Icons.share),
                        onTapButton: () => Provider.of<ShareStore>(context, listen: false).share(
                          article.title,
                          article.body,
                          article.beforeImageURL,
                        ),
                      ),
                      if (Provider.of<ArticleRepository>(context).isMyArticle(article))
                        IconButtonWithSplash(
                          width: 45,
                          height: 45,
                          icon: Icon(Icons.delete),
                          onTapButton: () {
                            Provider.of<ArticleRepository>(context, listen: false).deleteArticle(article);
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
