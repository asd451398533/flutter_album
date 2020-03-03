/*
 * @author lsy
 * @date   2020-02-26
 **/
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class CameraModel extends BaseModel {
  LiveData<String> imageLive = LiveData();
  LiveData<bool> maskLive = new LiveData();

  Future<List<String>> tackPic(CameraController controller, bool before) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String savePath =
        "${appDocDir.path}/PIC_${DateTime.now().millisecondsSinceEpoch}.jpeg";
    String scareSavePath =
        "${appDocDir.path}/PIC_SCARE_${DateTime.now().millisecondsSinceEpoch}.jpeg";
    await controller.takePicture(savePath);
    await compute(flipImage, [savePath,scareSavePath,Platform.isAndroid && before?"Y":"N"]);
    return [savePath,scareSavePath];
  }

  @override
  void dispose() {
    imageLive.dispost();
    maskLive.dispost();
  }
}

void flipImage(List<String> data) async {
  var readAsBytesSync = await File(data[0]).readAsBytes();
  Image image = decodeImage(readAsBytesSync);
  if(data[2]=="Y"){
    image = flip(image, Flip.horizontal);
    await File(data[0]).writeAsBytes(encodeJpg(image), flush: true);
  }
  Image thumbnail = copyResize(image, width: 560);
  await File(data[1]).writeAsBytes(encodeJpg(thumbnail), flush: true);
}
