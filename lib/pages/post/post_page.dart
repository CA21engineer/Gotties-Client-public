import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gottiesclient/models/entities/category.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:gottiesclient/pages/post/input_category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  File _beforeImage;
  File _afterImage;
  String title;
  String body;
  bool _isLoading = false;
  Category selectedCategory;

  Future<void> _getBeforeImage() async {
    final beforeImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _beforeImage = beforeImage;
    });
  }

  Future<void> _getAfterImage() async {
    final afterImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _afterImage = afterImage;
    });
  }

  Future<void> _confirmPost() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => AlertDialog(
        title: const Text('投稿の確認'),
        content: const Text('投稿しますか？'),
        actions: <Widget>[
          FlatButton(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.pop<void>(context);
            },
          ),
          FlatButton(
            child: const Text('はい'),
            onPressed: () async {
              if (_isLoading) {
                return;
              }
              try {
                setState(() {
                  _isLoading = true;
                });
                //ダイアログ出す→トップに戻る確認は以下の3行をコメントアウトした状態で行いました！
                await Provider.of<ArticleRepository>(context, listen: false)
                    .postArticle(title, _beforeImage, _afterImage, body, selectedCategory.id);
                setState(() {
                  _isLoading = false;
                });
                await showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (_) => AlertDialog(
                    title: const Text('投稿が完了しました！'),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('OK'),
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              } on Exception catch (e) {
                //TODO:エラー時の処理を書く
                debugPrint(e.toString());
              }
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget imagePlaceholderText() {
    return TextFormField(
      initialValue: 'No image selected',
      readOnly: true,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      validator: (_) {
        return '画像を選択してください。';
      },
    );
  }

  @override
  void initState() {
    Provider.of<CategoryRepository>(context, listen: false).getCategories();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedCategory = Provider.of<CategoryRepository>(context).selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'タイトル',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '劇的なタイトルを入力しましょう！',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'タイトルを入力してください。';
                    }
                    return '';
                  },
                  onChanged: (inputTitle) {
                    title = inputTitle;
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 96,
                      child: const Text(
                        'Before',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: _getBeforeImage,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: BorderSide(color: Colors.red),
                      ),
                      child: const Text('画像を選択'),
                    )
                  ],
                ),
                Container(
                  child: _beforeImage == null ? imagePlaceholderText() : Image.file(_beforeImage),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 96,
                      child: const Text(
                        'After',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: _getAfterImage,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: BorderSide(color: Colors.red),
                      ),
                      child: const Text('画像を選択'),
                    ),
                  ],
                ),
                Container(
                  child: _afterImage == null ? imagePlaceholderText() : Image.file(_afterImage),
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  '内容',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'どんなふうにお掃除した？',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onChanged: (inputBody) async {
                    body = inputBody;
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  'カテゴリ',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                InputCategory(),
                const SizedBox(
                  height: 32,
                ),
                Center(
                  child: Builder(builder: (context) {
                    return FlatButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32), side: BorderSide(color: Colors.red)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        ),
                        child: Text(
                          '投稿する！',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // TODO _formKey.currentState.validate()でちゃんとバリデーションできるようにする
                      onPressed: _confirmPost,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
