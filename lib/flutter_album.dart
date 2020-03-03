library flutter_album;

import 'package:flutter/material.dart';

import 'page/album/AlbumPage.dart';

/// A Calculator.
class GMAblum {
  Widget getAlbumPage(
      bool showCamera, int bigSelectSize, List<String> selectedImages,
      {String provider,
      int maxVideoCount = 0,
      videoSelectPath,
      noVideoHint = null,
      needAiCamera = false}) {
    return AlbumPage(provider, showCamera, bigSelectSize, selectedImages,
        maxVideoCount, videoSelectPath, noVideoHint, needAiCamera);
  }
}
