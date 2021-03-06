/*
 * @author lsy
 * @date   2019-11-01
 **/
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_album/sdk/photo_view_gallery.dart';
import 'package:flutter_album/sdk/src/photo_view_computed_scale.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gengmei_flutter_plugin/ScanImagePlugn.dart';

import '../../BaseComponent.dart';
import 'AlbumPreviewModel.dart';

class AlbumPreviewPage extends StatefulWidget {
  AlbumPreviewModel _model;
  List<ScanImageItem> fromPage;
  int startIndex;

  AlbumPreviewPage(String imgPath, int size, this.fromPage, int maxPhotoCount,
      int maxVideoCount, String hint, this.startIndex) {
    _model =
        AlbumPreviewModel(imgPath, size, maxPhotoCount, maxVideoCount, hint);
  }

  @override
  State<StatefulWidget> createState() => AlbumPreviewState(_model, fromPage);
}

class AlbumPreviewState extends State<AlbumPreviewPage>
    with SingleTickerProviderStateMixin {
  AlbumPreviewModel _model;
  PageController _pageController;
  Size _size;
  Animation<Offset> animation;
  AnimationController controller;
  bool showPop = true;
  int pageIndex;

  AlbumPreviewState(this._model, List<ScanImageItem> fromPage) {
    _model.setList(fromPage);
  }

  @override
  void initState() {
    super.initState();
    _model.init(context);
    _pageController = PageController(initialPage: widget.startIndex);
    _pageController.addListener(() {});
    _model.pageIndex(widget.startIndex);
    controller = new AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    animation =
        Tween(begin: Offset(0, 0), end: Offset(0, -1)).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: Container(
                color: Colors.black,
                child: Stack(
                  children: <Widget>[
                    getPage(),
                    SlideTransition(
                      position: animation,
                      child: Container(
                        width: double.maxFinite,
                        height: 80,
                        alignment: Alignment.center,
                        color: Colors.black38,
                        child: Stack(
//                      alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            Positioned(
                              left: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, _model.currentIndex);
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.only(
                                      left: 22,
                                      top: 38,
                                    ),
                                    child: SvgPicture.asset(
                                      "images/left_arrow.svg",
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              width: double.maxFinite,
                              height: 80,
                              padding: EdgeInsets.only(top: 41),
                              child: StreamBuilder<String>(
                                stream: _model.titleLive.stream,
                                initialData: _model.titleLive.data,
                                builder: (con, data) {
                                  if (data.data == null) {
                                    return baseText("", 16, Color(0xffFFFFFF));
                                  }
                                  return baseText(
                                      data.data, 16, Color(0xffFFFFFF));
                                },
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: StreamBuilder<int>(
                                  stream: _model.nextLive.stream,
                                  initialData: _model.nextLive.data,
                                  builder: (con, data) {
                                    if (data.data == null || data.data == 0) {
                                      return Container(
                                        alignment: Alignment.topRight,
                                        width: 110,
                                        height: 110,
                                        padding:
                                            EdgeInsets.only(right: 22, top: 39),
                                        child: baseText(
                                            "下一步", 16, Color(0xffC4C4C4)),
                                      );
                                    }
                                    return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.pop(context, -1);
                                        },
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          width: 110,
                                          height: 110,
                                          padding: EdgeInsets.only(
                                              right: 22, top: 39),
                                          child: baseText("下一步(${data.data})",
                                              16, Color(0xffFFFFFF)),
                                        ));
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: 0,
                      child: GestureDetector(
                          onTap: () {
                            _model.clickItem(context);
                          },
                          child: StreamBuilder<bool>(
                              stream: _model.selectLive.stream,
                              initialData: _model.selectLive.data,
                              builder: (con, data) {
                                if (data.data == null || !data.data) {
                                  return Container(
                                      color: Colors.transparent,
                                      padding: EdgeInsets.only(
                                          top: 20, right: 22, bottom: 20),
                                      child: SvgPicture.asset(
                                          "images/album_not_sel.svg"));
                                }
                                return Container(
                                    padding: EdgeInsets.only(
                                        top: 20, right: 22, bottom: 20),
                                    color: Colors.transparent,
                                    child: SvgPicture.asset(
                                        "images/album_sel.svg"));
                              })),
                    ),
                  ],
                ))));
  }

  getPage() {
    return StreamBuilder<List<ScanImageItem>>(
      stream: _model.pageList.stream,
      initialData: _model.pageList.data,
      builder: (con, data) {
        return PhotoViewGallery.builder(
          loadingBuilder: (c, Im, index) {
            return ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Image.file(
                File(data.data[index].path),
                fit: BoxFit.fitWidth,
              ),
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (con, index) {
            pageIndex = index;
            _model.getRealPath(context, index);
            if (data.data != null && data.data[index].isVideo) {
              return PhotoViewGalleryPageOptions.customChild(
                  childSize: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      ConstrainedBox(
                          constraints: BoxConstraints.expand(),
                          child: GestureDetector(
                            onTap: () {
                              hide();
                            },
                            child: Image.file(File(data.data[index].path),
                                fit: BoxFit.fitWidth),
                          )),
                      GestureDetector(
                        onTap: () {
                          _model.playVideo();
                        },
                        child: Icon(
                          Icons.play_circle_filled,
                          size: 80,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ));
            }
            if (data.data != null &&
                (Platform.isIOS &&
                    !data.data[index].isVideo &&
                    data.data[index].realPath.isNotEmpty &&
                    data.data[index].data == null)) {
              return PhotoViewGalleryPageOptions(
                onTapUp: (con, a, b) => hide(),
                imageProvider: FileImage(File(data.data[index].realPath)),
                initialScale: PhotoViewComputedScale.contained * 0.99,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.covered * 1.5,
              );
            }
            if (data.data == null ||
                (Platform.isIOS &&
                    !data.data[index].isVideo &&
                    data.data[index].data == null)) {
//              return PhotoViewGalleryPageOptions();
              return PhotoViewGalleryPageOptions.customChild(
                  childSize: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: Image.file(
                      File(data.data[index].path),
                      fit: BoxFit.fitWidth,
                    ),
                  ));
              //loadingItem()
            } else {
              return PhotoViewGalleryPageOptions(
                onTapUp: (con, a, b) => hide(),
                imageProvider: Platform.isAndroid
                    ? FileImage(File(data.data[index].realPath))
                    : MemoryImage(data.data[index].data),
                initialScale: PhotoViewComputedScale.contained * 0.99,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.covered * 1.5,
              );
            }
          },
          itemCount: _model.fromPage.length,
          pageController: _pageController,
          onPageChanged: (index) {
            _model.pageIndex(index);
          },
        );
      },
    );
  }

  hide() {
    if (showPop) {
      controller.forward();
    } else {
      controller.reverse();
    }
    showPop = !showPop;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _model.dispose();
    controller.dispose();
    super.dispose();
  }
//  @override
//  String pageName() {
//    return "album_preview";
//  }
//
//  @override
//  String referrer() {
//    return fromPage;
//  }
}
