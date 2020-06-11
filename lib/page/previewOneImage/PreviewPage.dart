/*
 * @author lsy
 * @date   2020/6/11
 **/
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_album/BaseComponent.dart';
import 'package:flutter_album/sdk/photo_view.dart';

class PreviewPage extends StatefulWidget {
  String url;
  String path;
  String flyKey;

  PreviewPage({this.url, this.path, this.flyKey});

  @override
  State<StatefulWidget> createState() => PreviewState();
}

class PreviewState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          appBar: baseAppBar(
              centerTitle: true,
              backClick: () {
                Navigator.pop(context);
              },
              title: "预览"),
          body: ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Hero(
                  tag: widget.flyKey,
                  child: PhotoView(
                    imageProvider: widget.url != null
                        ? NetworkImage(widget.url)
                        : FileImage(File(widget.path)),
                  ))),
        ));
  }
}
