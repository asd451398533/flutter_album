import 'package:flutter/material.dart';
import 'package:flutter_album/camera/CameraInstance.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_album/flutter_album.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CameraInstance.getInstance();
    return MaterialApp(
      title: 'MagicAi',
      home: GMAblum().getAlbumPage(true, 9, null),
    );
  }
}
