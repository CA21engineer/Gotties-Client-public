import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gottiesclient/models/models.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/pages/profile/widgets/profile_page_view.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Article> articles = Provider.of<ArticleStore>(context).articles;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfffefefe),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(8),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '投稿した Before After',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 250,
            child: ProfilePageView(
              articles: articles,
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(8),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'いいねした Before After',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 250,
            child: ProfilePageView(
              articles: articles,
            ),
          ),
        ],
      ),
    );
  }
}
