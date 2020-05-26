import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gottiesclient/models/stores/stores.dart';
import 'package:provider/provider.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({this.beforeImageURL, this.afterImageURL});

  final String beforeImageURL;
  final String afterImageURL;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height * 0.76;
    final _isAndroid = Platform.isAndroid;
    return Container(
      height: _height,
      child: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: _height),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: CachedNetworkImage(
                imageUrl: beforeImageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: _height),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Opacity(
                opacity: Provider.of<DetailStore>(context).playPositionRate,
                child: CachedNetworkImage(
                  imageUrl: afterImageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 10,
              sigmaX: 10,
            ),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: _height),
            child: CachedNetworkImage(
              progressIndicatorBuilder: (context, url, downloadProgress) {
                if (downloadProgress.progress == 1.0) {
                  print('画像取得終わり！');
                }
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ),
                );
              },
              imageUrl: beforeImageURL,
              fit: BoxFit.fitWidth,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: _height),
            child: Opacity(
              opacity: Provider.of<DetailStore>(context).playPositionRate,
              child: CachedNetworkImage(
                imageUrl: afterImageURL,
                fit: BoxFit.fitWidth,
                fadeOutDuration: const Duration(seconds: 1),
                fadeInDuration: const Duration(seconds: 1),
                errorWidget: (context, url, dynamic error) => Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 5, top: 0),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                iconSize: 30,
                color: Colors.white,
                icon: _isAndroid ? Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 15,
            child: ButtonTheme(
              height: 30,
              minWidth: 70,
              child: RaisedButton(
                onPressed: () => Provider.of<DetailStore>(context, listen: false).pauseRestartBeforeAfter(),
                color: Colors.white.withOpacity(0),
                shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 2)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Provider.of<DetailStore>(context).isPlaying ? '一時停止' : '再生',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 4,
                    ),
                    Icon(
                      Provider.of<DetailStore>(context).isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
