import 'package:flutter/material.dart';
import 'package:gottiesclient/models/entities/entities.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:gottiesclient/util/typedefs.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({this.article, this.onTapTile});

  @required
  final Article article;
  @required
  final VoidArticleFunction onTapTile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => onTapTile(article),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: article.beforeImageURL ?? '',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    fit: BoxFit.fitHeight,
                    imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/account_circle/normal.png',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 9 / 16,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                      child: Text(article.category.title),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                      icon: Icon(
                        Provider.of<ArticleRepository>(context).isLike(article.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async {
                        final repository = Provider.of<ArticleRepository>(context, listen: false);
                        final isLike = repository.isLike(article.id);
                        if(isLike){
                          await repository.unlikeArticle(article.id);
                        }else{
                          await repository.likeArticle(article.id);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        Provider.of<ShareStore>(context, listen: false).share(
                          article.title,
                          article.body,
                          article.beforeImageURL,
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Text(
                    article.title ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
