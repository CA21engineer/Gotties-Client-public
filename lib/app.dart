import 'package:flutter/material.dart';
import 'package:gottiesclient/models/models.dart';
import 'package:gottiesclient/models/stores/post_page_store.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/pages/detail/detail_page.dart';
import 'package:gottiesclient/pages/home/home_page.dart';
import 'package:gottiesclient/pages/login/login_page.dart';
import 'package:gottiesclient/pages/post/post_page.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginStore(),
        ),
        Provider<BaseClient>.value(
          value: FirestoreClient(),
        ),
      ],
      child: Consumer2<LoginStore, BaseClient>(
        builder: (_, loginStore, client, ___) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ArticleRepository(loginStore, client),
              ),
              ChangeNotifierProvider(
                create: (_) => CategoryRepository(client),
              ),
              ChangeNotifierProvider(
                create: (_) => PostPageStore(),
              ),
              Provider(
                create: (_) => FocusNodeStore(),
                dispose: (_, FocusNodeStore store) {
                  store.focusNode.dispose();
                },
              ),
              Provider<ShareStore>.value(
                value: ShareStore(),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.red,
                fontFamily: 'NotoSansJP-Regular',
              ),
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/':
                    return MaterialPageRoute<void>(
                      builder: (_) => HomePage(),
                    );
                  case '/detail':
                    return MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        final article = settings.arguments as Article;
                        return DetailPage(article: article);
                      },
                    );
                  case '/post':
                    return MaterialPageRoute<void>(
                      builder: (_) => PostPage(),
                    );
                  case '/login':
                    return MaterialPageRoute<void>(
                      builder: (_) => LoginPage(),
                      fullscreenDialog: true,
                    );
                  default:
                    throw UnimplementedError('Undefined route ${settings.name}');
                }
              },
            ),
          );
        },
      ),
    );
  }
}
