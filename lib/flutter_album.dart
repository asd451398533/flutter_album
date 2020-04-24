library flutter_album;

import 'package:flutter/material.dart';
import 'package:flutter_album/page/camera/CameraPage.dart';

import 'page/album/AlbumPage.dart';

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
